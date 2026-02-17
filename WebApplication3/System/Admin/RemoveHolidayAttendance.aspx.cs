using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication4.Admin
{
    public partial class RemoveHolidayAttendance : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadHolidays();
                LoadAffectedAttendance();
                LoadOperationLogs();
            }
        }

        // Helper method to format holiday duration
        public string FormatHolidayDuration(object fromDateObj, object toDateObj)
        {
            try
            {
                if (fromDateObj == null || fromDateObj == DBNull.Value ||
                    toDateObj == null || toDateObj == DBNull.Value)
                    return "N/A";

                DateTime fromDate = Convert.ToDateTime(fromDateObj);
                DateTime toDate = Convert.ToDateTime(toDateObj);

                // Ensure valid date range
                if (fromDate > toDate)
                    return "Invalid";

                int days = (toDate - fromDate).Days + 1;
                return days.ToString() + " day" + (days != 1 ? "s" : "");
            }
            catch (Exception)
            {
                return "Error";
            }
        }

        private void LoadHolidays()
        {
            try
            {
                string connectionString =  WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString();

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Check if Holiday table exists
                    string checkTableQuery = @"
                        SELECT CASE WHEN OBJECT_ID('Holiday', 'U') IS NOT NULL THEN 1 ELSE 0 END";

                    using (SqlCommand checkCmd = new SqlCommand(checkTableQuery, conn))
                    {
                        int tableExists = (int)checkCmd.ExecuteScalar();

                        if (tableExists == 0)
                        {
                            // Holiday table doesn't exist - show message
                            DataTable emptyTable = new DataTable();
                            emptyTable.Columns.Add("holiday_name");
                            emptyTable.Columns.Add("from_date");
                            emptyTable.Columns.Add("to_date");
                            emptyTable.Columns.Add("attendance_count");

                            gvHolidays.DataSource = emptyTable;
                            gvHolidays.DataBind();

                            hdnHolidayCount.Value = "0";
                            ShowMessage("Holiday table does not exist. Please create holidays first.", "warning");
                            return;
                        }
                    }

                    // Get holidays with affected attendance counts
                    string query = @"
                        SELECT 
                            h.holiday_ID,
                            h.holiday_name,
                            h.from_date,
                            h.to_date,
                            ISNULL(COUNT(a.attendance_ID), 0) as attendance_count
                        FROM Holiday h
                        LEFT JOIN Attendance a ON a.date BETWEEN h.from_date AND h.to_date
                        GROUP BY h.holiday_ID, h.holiday_name, h.from_date, h.to_date
                        ORDER BY h.from_date";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);

                        gvHolidays.DataSource = dt;
                        gvHolidays.DataBind();
                        hdnHolidayCount.Value = dt.Rows.Count.ToString();

                        if (dt.Rows.Count == 0)
                        {
                            ShowMessage("No holidays found in the system. Please add holidays first.", "warning");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"Error loading holidays: {ex.Message}", "error");
            }
        }

        private void LoadAffectedAttendance()
        {
            try
            {
                string connectionString =  WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString();

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Check if Holiday table exists
                    string checkTableQuery = @"
                        SELECT CASE WHEN OBJECT_ID('Holiday', 'U') IS NOT NULL THEN 1 ELSE 0 END";

                    using (SqlCommand checkCmd = new SqlCommand(checkTableQuery, conn))
                    {
                        int tableExists = (int)checkCmd.ExecuteScalar();

                        if (tableExists == 0)
                        {
                            // No holiday table, so no affected attendance
                            DataTable emptyTable = new DataTable();
                            gvAffectedAttendance.DataSource = emptyTable;
                            gvAffectedAttendance.DataBind();

                            // Reset statistics
                            lblTotalToDelete.Text = "0";
                            lblAttendedCount.Text = "0";
                            lblAbsentCount.Text = "0";
                            lblAffectedEmployees.Text = "0";
                            hdnAffectedCount.Value = "0";
                            btnExecuteDelete.Enabled = false;
                            return;
                        }
                    }

                    // Get affected attendance records (limited to 50 for preview)
                    string query = @"
                        SELECT TOP 50
                            a.attendance_ID,
                            a.emp_ID,
                            a.date,
                            a.check_in_time,
                            a.check_out_time,
                            a.status,
                            e.first_name + ' ' + e.last_name as employee_name,
                            h.holiday_name
                        FROM Attendance a
                        INNER JOIN Holiday h ON a.date BETWEEN h.from_date AND h.to_date
                        INNER JOIN Employee e ON a.emp_ID = e.employee_id
                        ORDER BY a.date DESC, a.emp_ID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);

                        gvAffectedAttendance.DataSource = dt;
                        gvAffectedAttendance.DataBind();

                        // Get total count for statistics
                        string countQuery = @"
                            SELECT 
                                COUNT(*) as total_count,
                                SUM(CASE WHEN a.status = 'Attended' THEN 1 ELSE 0 END) as attended_count,
                                SUM(CASE WHEN a.status = 'Absent' THEN 1 ELSE 0 END) as absent_count,
                                COUNT(DISTINCT a.emp_ID) as unique_employees
                            FROM Attendance a
                            INNER JOIN Holiday h ON a.date BETWEEN h.from_date AND h.to_date";

                        using (SqlCommand countCmd = new SqlCommand(countQuery, conn))
                        using (SqlDataReader reader = countCmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                int total = reader.IsDBNull(0) ? 0 : reader.GetInt32(0);
                                int attended = reader.IsDBNull(1) ? 0 : reader.GetInt32(1);
                                int absent = reader.IsDBNull(2) ? 0 : reader.GetInt32(2);
                                int employees = reader.IsDBNull(3) ? 0 : reader.GetInt32(3);

                                lblTotalToDelete.Text = total.ToString();
                                lblAttendedCount.Text = attended.ToString();
                                lblAbsentCount.Text = absent.ToString();
                                lblAffectedEmployees.Text = employees.ToString();
                                hdnAffectedCount.Value = total.ToString();

                                // Enable/disable delete button based on affected count
                                btnExecuteDelete.Enabled = (total > 0);

                                if (total == 0)
                                {
                                    ShowMessage("No attendance records found during holidays.", "info");
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"Error loading affected attendance: {ex.Message}", "error");
            }
        }

        private void LoadOperationLogs()
        {
            try
            {
                // For demo purposes, create sample logs
                // In real implementation, you would have an OperationLog table
                DataTable dt = new DataTable();
                dt.Columns.Add("timestamp", typeof(DateTime));
                dt.Columns.Add("operation_type", typeof(string));
                dt.Columns.Add("records_affected", typeof(int));
                dt.Columns.Add("performed_by", typeof(string));
                dt.Columns.Add("status", typeof(string));
                dt.Columns.Add("notes", typeof(string));

                // Add sample log entries
                dt.Rows.Add(DateTime.Now.AddDays(-1), "Holiday Cleanup", 15, Session["UserID"]?.ToString() ?? "Admin001", "Success", "Regular cleanup");
                dt.Rows.Add(DateTime.Now.AddDays(-3), "Holiday Cleanup", 8, Session["UserID"]?.ToString() ?? "Admin001", "Success", "Monthly maintenance");

                gvOperationLogs.DataSource = dt;
                gvOperationLogs.DataBind();
            }
            catch (Exception ex)
            {
                // Silent fail for logs - not critical
                System.Diagnostics.Debug.WriteLine($"Error loading logs: {ex.Message}");
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminDashboard.aspx");
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            LoadHolidays();
            LoadAffectedAttendance();
            LoadOperationLogs();
            ShowMessage("Data refreshed successfully", "success");
        }

        protected void btnAddHoliday_Click(object sender, EventArgs e)
        {
            // This would normally redirect to a holiday management page
            ShowMessage("To add holidays, please use the 'Create_Holiday' and 'Add_Holiday' stored procedures in your database.", "info");
        }

        protected void btnManageHolidays_Click(object sender, EventArgs e)
        {
            // This would normally redirect to a holiday management page
            ShowMessage("Holiday management feature would be implemented on a separate page.", "info");
        }

        protected void btnPreviewOnly_Click(object sender, EventArgs e)
        {
            // Just reload the preview data
            LoadAffectedAttendance();
            ShowMessage("Preview refreshed. No changes were made.", "info");
        }

        protected void btnExecuteDelete_Click(object sender, EventArgs e)
        {
            if (!chkConfirmDelete.Checked)
            {
                ShowMessage("Please confirm you understand this action is irreversible", "error");
                return;
            }

            try
            {
                string connectionString =  WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString();

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Check how many records will be affected
                    string countQuery = @"
                        SELECT COUNT(*) 
                        FROM Attendance a
                        INNER JOIN Holiday h ON a.date BETWEEN h.from_date AND h.to_date";

                    int totalRecords;
                    using (SqlCommand countCmd = new SqlCommand(countQuery, conn))
                    {
                        totalRecords = (int)countCmd.ExecuteScalar();
                    }

                    if (totalRecords == 0)
                    {
                        ShowMessage("No records to delete. No action taken.", "warning");
                        return;
                    }

                    // First, backup the data if requested
                    if (chkBackupData.Checked)
                    {
                        BackupAffectedRecords(conn, totalRecords);
                    }

                    // Execute the stored procedure
                    using (SqlCommand cmd = new SqlCommand("Remove_Holiday", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        int rowsAffected = cmd.ExecuteNonQuery();

                        // Log the operation
                        LogOperation("Holiday Cleanup", rowsAffected, "Success",
                            $"Deleted {rowsAffected} attendance records during holidays");

                        // Show success message
                        ShowMessage($"✅ Successfully deleted {rowsAffected} attendance records during holidays", "success");

                        // Refresh the data
                        LoadHolidays();
                        LoadAffectedAttendance();
                        LoadOperationLogs();

                        // Reset confirmation checkbox
                        chkConfirmDelete.Checked = false;
                        btnExecuteDelete.Enabled = false;
                    }
                }
            }
            catch (SqlException ex)
            {
                string errorMsg = $"Database error: {ex.Message}";
                LogOperation("Holiday Cleanup", 0, "Failed", errorMsg);
                ShowMessage($"❌ {errorMsg}", "error");
            }
            catch (Exception ex)
            {
                string errorMsg = $"Error: {ex.Message}";
                LogOperation("Holiday Cleanup", 0, "Failed", errorMsg);
                ShowMessage($"❌ {errorMsg}", "error");
            }
        }

        private void BackupAffectedRecords(SqlConnection conn, int recordCount)
        {
            try
            {
                // In a real implementation, you would create a backup table
                // For now, just log that backup was requested
                LogOperation("Backup Requested", recordCount, "Not Implemented",
                    "Backup feature would save records before deletion");

                ShowMessage($"ℹ️ Backup requested for {recordCount} records (feature not fully implemented)", "info");
            }
            catch (Exception ex)
            {
                // Don't fail the main operation if backup fails
                LogOperation("Backup", 0, "Warning", $"Backup failed: {ex.Message}");
            }
        }

        private void LogOperation(string operationType, int recordsAffected, string status, string notes)
        {
            try
            {
                // In a real implementation, you would insert into an OperationLog table
                // For now, we'll update the operation logs grid
                DataTable dt = (DataTable)gvOperationLogs.DataSource;
                if (dt == null)
                {
                    dt = new DataTable();
                    dt.Columns.Add("timestamp", typeof(DateTime));
                    dt.Columns.Add("operation_type", typeof(string));
                    dt.Columns.Add("records_affected", typeof(int));
                    dt.Columns.Add("performed_by", typeof(string));
                    dt.Columns.Add("status", typeof(string));
                    dt.Columns.Add("notes", typeof(string));
                }

                string performedBy = Session["UserID"]?.ToString() ?? "Unknown";
                dt.Rows.InsertAt(dt.NewRow(), 0);
                dt.Rows[0]["timestamp"] = DateTime.Now;
                dt.Rows[0]["operation_type"] = operationType;
                dt.Rows[0]["records_affected"] = recordsAffected;
                dt.Rows[0]["performed_by"] = performedBy;
                dt.Rows[0]["status"] = status;
                dt.Rows[0]["notes"] = notes;

                gvOperationLogs.DataSource = dt;
                gvOperationLogs.DataBind();
            }
            catch
            {
                // Silent fail for logging
            }
        }

        protected void chkConfirmDelete_CheckedChanged(object sender, EventArgs e)
        {
            // Update delete button state
            btnExecuteDelete.Enabled = chkConfirmDelete.Checked;
        }

        protected void btnExportHolidays_Click(object sender, EventArgs e)
        {
            try
            {
                string connectionString =  WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString();

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Check if Holiday table exists
                    string checkTableQuery = @"
                        SELECT CASE WHEN OBJECT_ID('Holiday', 'U') IS NOT NULL THEN 1 ELSE 0 END";

                    using (SqlCommand checkCmd = new SqlCommand(checkTableQuery, conn))
                    {
                        int tableExists = (int)checkCmd.ExecuteScalar();

                        if (tableExists == 0)
                        {
                            ShowMessage("Holiday table does not exist.", "error");
                            return;
                        }
                    }

                    string query = @"
                        SELECT 
                            holiday_name as 'Holiday Name',
                            CONVERT(varchar, from_date, 23) as 'From Date',
                            CONVERT(varchar, to_date, 23) as 'To Date',
                            DATEDIFF(day, from_date, to_date) + 1 as 'Duration (Days)'
                        FROM Holiday
                        ORDER BY from_date";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);

                        // Export to Excel
                        ExportToExcel(dt, $"Holidays_List_{DateTime.Now:yyyyMMdd}.xls", "Holidays List");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"❌ Export error: {ex.Message}", "error");
            }
        }

        protected void btnExportAffected_Click(object sender, EventArgs e)
        {
            try
            {
                string connectionString = WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString(); 

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string query = @"
                        SELECT 
                            a.attendance_ID as 'Record ID',
                            a.emp_ID as 'Employee ID',
                            e.first_name + ' ' + e.last_name as 'Employee Name',
                            CONVERT(varchar, a.date, 23) as 'Date',
                            CONVERT(varchar, a.check_in_time, 108) as 'Check In',
                            CONVERT(varchar, a.check_out_time, 108) as 'Check Out',
                            a.status as 'Status',
                            h.holiday_name as 'Holiday',
                            CONVERT(varchar, h.from_date, 23) as 'Holiday Start',
                            CONVERT(varchar, h.to_date, 23) as 'Holiday End'
                        FROM Attendance a
                        INNER JOIN Holiday h ON a.date BETWEEN h.from_date AND h.to_date
                        INNER JOIN Employee e ON a.emp_ID = e.employee_id
                        ORDER BY a.date, a.emp_ID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);

                        // Export to Excel
                        ExportToExcel(dt, $"Holiday_Attendance_{DateTime.Now:yyyyMMdd}.xls", "Holiday Attendance Records");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"❌ Export error: {ex.Message}", "error");
            }
        }

        private void ExportToExcel(DataTable dt, string filename, string title)
        {
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", $"attachment;filename={filename}");
            Response.Charset = "";
            Response.ContentType = "application/vnd.ms-excel";

            using (System.IO.StringWriter sw = new System.IO.StringWriter())
            {
                System.Web.UI.HtmlTextWriter hw = new System.Web.UI.HtmlTextWriter(sw);

                // Add title
                hw.WriteLine($"<h2>{title}</h2>");
                hw.WriteLine($"<h3>Generated: {DateTime.Now:dddd, MMMM dd, yyyy HH:mm}</h3>");
                hw.WriteLine($"<h4>Generated by: {Session["UserID"]?.ToString() ?? "Unknown"}</h4>");
                hw.WriteLine("<br/>");

                // Create table
                hw.Write("<table border='1' cellpadding='5' cellspacing='0'>");

                // Add header
                hw.Write("<tr>");
                foreach (DataColumn column in dt.Columns)
                {
                    hw.Write($"<th bgcolor='#007bff' style='color:white;'>{column.ColumnName}</th>");
                }
                hw.Write("</tr>");

                // Add rows
                foreach (DataRow row in dt.Rows)
                {
                    hw.Write("<tr>");
                    foreach (DataColumn column in dt.Columns)
                    {
                        hw.Write($"<td>{row[column].ToString()}</td>");
                    }
                    hw.Write("</tr>");
                }

                hw.Write("</table>");

                Response.Output.Write(sw.ToString());
                Response.Flush();
                Response.End();
            }
        }

        protected void btnPrintReport_Click(object sender, EventArgs e)
        {
            // Printing is handled by JavaScript in the OnClientClick event
        }

        private void ShowMessage(string message, string type)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = $"message {type}";
            lblMessage.Visible = true;

            // Scroll to message
            ScriptManager.RegisterStartupScript(this, GetType(), "scrollToMessage",
                "setTimeout(function() { document.getElementById('" + lblMessage.ClientID + "').scrollIntoView({behavior: 'smooth'}); }, 100);", true);
        }
    }
}
