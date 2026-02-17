using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication4.Admin
{
    public partial class YesterdayAttendance : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hdnYesterdayDate.Value = DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd");
                LoadYesterdayAttendance();
            }
        }

        private void LoadYesterdayAttendance()
        {
            try
            {
                string connectionString =WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString();

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Use the existing view: allEmployeeAttendance
                    string query = @"SELECT a.*, 
                                    e.first_name + ' ' + e.last_name as employee_name,
                                    e.dept_name
                                    FROM allEmployeeAttendance a
                                    LEFT JOIN Employee e ON a.emp_ID = e.employee_id
                                    ORDER BY a.emp_ID, a.date";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);

                        // Bind to GridView
                        gvAttendance.DataSource = dt;
                        gvAttendance.DataBind();

                        // Update statistics
                        UpdateStatistics(dt);

                        // Show message
                        if (dt.Rows.Count > 0)
                        {
                            lblMessage.Text = $"✅ Found {dt.Rows.Count} attendance records for yesterday ({DateTime.Now.AddDays(-1):dddd, MMMM dd, yyyy})";
                            lblMessage.CssClass = "message success";
                            lblMessage.Visible = true;
                        }
                        else
                        {
                            lblMessage.Text = $"ℹ️ No attendance records found for yesterday ({DateTime.Now.AddDays(-1):dddd, MMMM dd, yyyy})";
                            lblMessage.CssClass = "message warning";
                            lblMessage.Visible = true;
                        }
                    }
                }
            }
            catch (SqlException ex)
            {
                lblMessage.Text = $"❌ Database error: {ex.Message}";
                lblMessage.CssClass = "message error";
                lblMessage.Visible = true;
            }
            catch (Exception ex)
            {
                lblMessage.Text = $"❌ Error: {ex.Message}";
                lblMessage.CssClass = "message error";
                lblMessage.Visible = true;
            }
        }

        private void UpdateStatistics(DataTable dt)
        {
            int total = dt.Rows.Count;
            int attended = 0;
            int absent = 0;

            foreach (DataRow row in dt.Rows)
            {
                string status = row["status"]?.ToString() ?? "";
                if (status.Equals("Attended", StringComparison.OrdinalIgnoreCase))
                    attended++;
                else if (status.Equals("Absent", StringComparison.OrdinalIgnoreCase))
                    absent++;
            }

            lblTotalRecords.Text = total.ToString();
            lblAttended.Text = attended.ToString();
            lblAbsent.Text = absent.ToString();
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            LoadYesterdayAttendance();
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminDashboard.aspx");
        }

        protected void btnViewEmployee_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string employeeId = btn.CommandArgument;

            // You can implement employee details view here
            // For now, show a message
            lblMessage.Text = $"ℹ️ Viewing details for Employee ID: {employeeId}";
            lblMessage.CssClass = "message warning";
            lblMessage.Visible = true;

            // Or redirect to employee details page
            // Response.Redirect($"EmployeeDetails.aspx?id={employeeId}");
        }

        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            try
            {
                string connectionString = WebConfigurationManager.ConnectionStrings["University_HR_ManagementSystem"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string query = @"SELECT 
                                    a.attendance_ID as 'Record ID',
                                    a.emp_ID as 'Employee ID',
                                    CONVERT(varchar, a.date, 23) as 'Date',
                                    CONVERT(varchar, a.check_in_time, 108) as 'Check In Time',
                                    CONVERT(varchar, a.check_out_time, 108) as 'Check Out Time',
                                    a.total_duration as 'Duration (Minutes)',
                                    a.status as 'Status',
                                    e.first_name + ' ' + e.last_name as 'Employee Name',
                                    e.dept_name as 'Department'
                                    FROM allEmployeeAttendance a
                                    LEFT JOIN Employee e ON a.emp_ID = e.employee_id
                                    ORDER BY a.emp_ID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);

                        // Export to Excel
                        ExportToExcel(dt, $"Yesterday_Attendance_{DateTime.Now.AddDays(-1):yyyyMMdd}.xls");
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = $"❌ Export error: {ex.Message}";
                lblMessage.CssClass = "message error";
                lblMessage.Visible = true;
            }
        }

        private void ExportToExcel(DataTable dt, string filename)
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
                hw.WriteLine("<h2>Yesterday's Attendance Report</h2>");
                hw.WriteLine($"<h3>Date: {DateTime.Now.AddDays(-1):dddd, MMMM dd, yyyy}</h3>");
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

        protected void btnExportPDF_Click(object sender, EventArgs e)
        {
            // PDF export would require a PDF library like iTextSharp
            lblMessage.Text = "ℹ️ PDF export feature requires additional setup";
            lblMessage.CssClass = "message warning";
            lblMessage.Visible = true;
        }

        protected void btnPrint_Click(object sender, EventArgs e)
        {
            // Printing is handled by JavaScript in the OnClientClick event
        }

        protected void gvAttendance_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvAttendance.PageIndex = e.NewPageIndex;
            LoadYesterdayAttendance();
        }
    }
}