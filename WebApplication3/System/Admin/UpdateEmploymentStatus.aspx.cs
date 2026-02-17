using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication4.Admin
{
    public partial class SimpleUpdateEmploymentStatus : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUpdatedEmployees();
            }
        }

        protected void gvUpdatedEmployees_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Get the status labels
                Label lblOldStatus = (Label)e.Row.FindControl("lblOldStatus");
                Label lblNewStatus = (Label)e.Row.FindControl("lblNewStatus");

                // Get status values from DataRow
                DataRowView rowView = (DataRowView)e.Row.DataItem;
                string oldStatus = rowView["old_status"].ToString();
                string newStatus = rowView["new_status"].ToString();

                // Set CSS classes based on status
                if (lblOldStatus != null)
                {
                    lblOldStatus.CssClass = GetStatusCssClass(oldStatus);
                }

                if (lblNewStatus != null)
                {
                    lblNewStatus.CssClass = GetStatusCssClass(newStatus);
                }
            }
        }

        private string GetStatusCssClass(string status)
        {
            string cssClass = "status-badge ";

            switch (status.ToLower())
            {
                case "active":
                    cssClass += "status-active";
                    break;
                case "onleave":
                    cssClass += "status-onleave";
                    break;
                case "notice_period":
                    cssClass += "status-notice";
                    break;
                case "resigned":
                    cssClass += "status-resigned";
                    break;
                default:
                    cssClass = "status-badge";
                    break;
            }

            return cssClass;
        }

        // Helper method to update badge labels
        private void UpdateStatusBadge(Label badgeLabel, string status, string text)
        {
            badgeLabel.Text = text;
            badgeLabel.CssClass = GetStatusCssClass(status);
        }

        protected void btnCheckStatus_Click(object sender, EventArgs e)
        {
            if (!int.TryParse(txtEmployeeID.Text.Trim(), out int employeeId))
            {
                ShowMessage("Please enter a valid Employee ID", "error");
                return;
            }

            try
            {
                string connectionString =  WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString();

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Check if employee exists
                    string checkQuery = @"
                SELECT employee_id, first_name + ' ' + last_name as full_name, 
                       employment_status
                FROM Employee 
                WHERE employee_id = @employeeId";

                    using (SqlCommand cmd = new SqlCommand(checkQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@employeeId", employeeId);

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                lblEmpID.Text = reader["employee_id"].ToString();
                                lblEmpName.Text = reader["full_name"].ToString();
                                string currentStatus = reader["employment_status"].ToString();

                                // Update current status badge
                                UpdateStatusBadge(lblCurrentStatusBadge, currentStatus, currentStatus);
                            }
                            else
                            {
                                ShowMessage("Employee not found", "error");
                                pnlEmployeeInfo.Visible = false;
                                return;
                            }
                        } // DataReader is closed here
                    }

                    // Now execute the second query since the DataReader is closed
                    string onLeaveQuery = "SELECT dbo.Is_On_Leave(@employeeId, CAST(GETDATE() AS DATE), CAST(GETDATE() AS DATE))";

                    using (SqlCommand leaveCmd = new SqlCommand(onLeaveQuery, conn))
                    {
                        leaveCmd.Parameters.AddWithValue("@employeeId", employeeId);
                        bool isOnLeave = (bool)leaveCmd.ExecuteScalar();

                        lblOnLeave.Text = isOnLeave ? "Yes" : "No";
                        string newStatus = isOnLeave ? "onleave" : "active";

                        // Update new status badge
                        UpdateStatusBadge(lblNewStatusBadge, newStatus, newStatus);
                    }

                    pnlEmployeeInfo.Visible = true;
                    ShowMessage($"Employee found. On leave today: {lblOnLeave.Text}", "info");
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"Error: {ex.Message}", "error");
            }
        }

        protected void btnUpdateSingle_Click(object sender, EventArgs e)
        {
            if (!int.TryParse(txtEmployeeID.Text.Trim(), out int employeeId))
            {
                ShowMessage("Please enter a valid Employee ID", "error");
                return;
            }

            try
            {
                string connectionString = WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString();

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Get current status before update
                    string currentStatusQuery = "SELECT employment_status FROM Employee WHERE employee_id = @employeeId";
                    string oldStatus = "";

                    using (SqlCommand statusCmd = new SqlCommand(currentStatusQuery, conn))
                    {
                        statusCmd.Parameters.AddWithValue("@employeeId", employeeId);
                        oldStatus = statusCmd.ExecuteScalar()?.ToString() ?? "";
                    }

                    // Execute the stored procedure
                    using (SqlCommand cmd = new SqlCommand("Update_Employment_Status", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@Employee_ID", employeeId);

                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            // Get new status
                            string newStatusQuery = "SELECT employment_status FROM Employee WHERE employee_id = @employeeId";
                            string newStatus = "";

                            using (SqlCommand newCmd = new SqlCommand(newStatusQuery, conn))
                            {
                                newCmd.Parameters.AddWithValue("@employeeId", employeeId);
                                newStatus = newCmd.ExecuteScalar()?.ToString() ?? "";
                            }

                            // Log the update
                            LogUpdate(employeeId, oldStatus, newStatus);

                            ShowMessage($"✅ Successfully updated Employee {employeeId}. Status changed from '{oldStatus}' to '{newStatus}'", "success");

                            // Refresh employee info
                            btnCheckStatus_Click(sender, e);

                            // Refresh list
                            LoadUpdatedEmployees();
                        }
                        else
                        {
                            ShowMessage("No changes made. Employee may not exist.", "warning");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"Error: {ex.Message}", "error");
            }
        }

        protected void btnUpdateAll_Click(object sender, EventArgs e)
        {
            try
            {
                string connectionString =  WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString();

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Get all active employees
                    string employeesQuery = @"
                        SELECT employee_id, employment_status 
                        FROM Employee 
                        WHERE employment_status IN ('active', 'onleave')";

                    DataTable employees = new DataTable();
                    using (SqlCommand cmd = new SqlCommand(employeesQuery, conn))
                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(employees);
                    }

                    int updatedCount = 0;
                    int errorCount = 0;

                    // Update each employee
                    foreach (DataRow row in employees.Rows)
                    {
                        int employeeId = Convert.ToInt32(row["employee_id"]);
                        string oldStatus = row["employment_status"].ToString();

                        try
                        {
                            // Check if on leave
                            string onLeaveQuery = "SELECT dbo.Is_On_Leave(@employeeId, CAST(GETDATE() AS DATE), CAST(GETDATE() AS DATE))";
                            bool isOnLeave;

                            using (SqlCommand leaveCmd = new SqlCommand(onLeaveQuery, conn))
                            {
                                leaveCmd.Parameters.AddWithValue("@employeeId", employeeId);
                                isOnLeave = (bool)leaveCmd.ExecuteScalar();
                            }

                            string expectedNewStatus = isOnLeave ? "onleave" : "active";

                            // Only update if status needs to change
                            if (!oldStatus.Equals(expectedNewStatus, StringComparison.OrdinalIgnoreCase))
                            {
                                using (SqlCommand cmd = new SqlCommand("Update_Employment_Status", conn))
                                {
                                    cmd.CommandType = CommandType.StoredProcedure;
                                    cmd.Parameters.AddWithValue("@Employee_ID", employeeId);
                                    cmd.ExecuteNonQuery();

                                    // Log the update
                                    LogUpdate(employeeId, oldStatus, expectedNewStatus);
                                    updatedCount++;
                                }
                            }
                        }
                        catch
                        {
                            errorCount++;
                        }
                    }

                    if (updatedCount > 0)
                    {
                        ShowMessage($"✅ Successfully updated {updatedCount} employee(s). {errorCount} error(s).", "success");
                    }
                    else if (errorCount > 0)
                    {
                        ShowMessage($"⚠️ No updates needed. {errorCount} error(s) occurred.", "warning");
                    }
                    else
                    {
                        ShowMessage("ℹ️ No employee statuses needed updating today.", "info");
                    }

                    // Refresh list
                    LoadUpdatedEmployees();
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"Error: {ex.Message}", "error");
            }
        }

        private void LogUpdate(int employeeId, string oldStatus, string newStatus)
        {
            try
            {
                // In a real system, you'd log to a database table
                // For now, we'll just update the grid view
                LoadUpdatedEmployees();
            }
            catch
            {
                // Silent fail for logging
            }
        }

        private void LoadUpdatedEmployees()
        {
            try
            {
                // For demonstration, show recent updates from today
                // In a real system, you'd query an update log table
                DataTable dt = new DataTable();
                dt.Columns.Add("employee_id", typeof(int));
                dt.Columns.Add("employee_name", typeof(string));
                dt.Columns.Add("old_status", typeof(string));
                dt.Columns.Add("new_status", typeof(string));
                dt.Columns.Add("updated_time", typeof(DateTime));

                // Add some sample data for demonstration
                dt.Rows.Add(1, "John Doe", "active", "onleave", DateTime.Now.AddMinutes(-5));
                dt.Rows.Add(2, "Jane Smith", "onleave", "active", DateTime.Now.AddMinutes(-3));

                gvUpdatedEmployees.DataSource = dt;
                gvUpdatedEmployees.DataBind();
            }
            catch (Exception ex)
            {
                // Silent fail
                System.Diagnostics.Debug.WriteLine($"Error loading updates: {ex.Message}");
            }
        }

        protected void btnRefreshList_Click(object sender, EventArgs e)
        {
            LoadUpdatedEmployees();
            ShowMessage("List refreshed", "info");
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminDashboard.aspx");
        }

        private void ShowMessage(string message, string type)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = $"message {type}";
            lblMessage.Visible = true;
        }
    }
}