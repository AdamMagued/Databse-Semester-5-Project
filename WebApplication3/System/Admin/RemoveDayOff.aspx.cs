using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication4.Admin
{
    public partial class SimpleRemoveDayOff : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
           
        }

        protected void btnLoad_Click(object sender, EventArgs e)
        {
            if (!int.TryParse(txtEmployeeID.Text.Trim(), out int employeeId))
            {
                ShowMessage("Please enter a valid Employee ID", "error");
                return;
            }

            try
            {
                string connectionString  = WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString();

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // 1. Get employee details
                    string employeeQuery = @"
                        SELECT first_name + ' ' + last_name as full_name, 
                               dept_name, official_day_off 
                        FROM Employee 
                        WHERE employee_id = @employeeId";

                    using (SqlCommand cmd = new SqlCommand(employeeQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@employeeId", employeeId);

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                lblEmployeeName.Text = reader["full_name"].ToString();
                                lblDepartment.Text = reader["dept_name"].ToString();
                                lblDayOff.Text = reader["official_day_off"].ToString();
                                pnlEmployeeInfo.Visible = true;
                            }
                            else
                            {
                                ShowMessage("Employee not found", "error");
                                pnlEmployeeInfo.Visible = false;
                                return;
                            }
                        }
                    }

                    // 2. Get unattended day off records for current month
                    string attendanceQuery = @"
                        SELECT 
                            a.attendance_ID,
                            a.date,
                            a.check_in_time,
                            a.check_out_time,
                            a.status
                        FROM Attendance a
                        INNER JOIN Employee e ON a.emp_ID = e.employee_id
                        WHERE a.emp_ID = @employeeId
                          AND YEAR(a.date) = YEAR(GETDATE())
                          AND MONTH(a.date) = MONTH(GETDATE())
                          AND UPPER(DATENAME(WEEKDAY, a.date)) = UPPER(e.official_day_off)
                          AND (
                            (a.status IS NOT NULL AND UPPER(a.status) = 'ABSENT')
                            OR (a.check_in_time IS NULL AND a.check_out_time IS NULL)
                          )
                        ORDER BY a.date";

                    using (SqlCommand cmd = new SqlCommand(attendanceQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@employeeId", employeeId);

                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            adapter.Fill(dt);

                            gvRecords.DataSource = dt;
                            gvRecords.DataBind();

                            // Update count label
                            if (dt.Rows.Count > 0)
                            {
                                lblCount.Text = $"Found {dt.Rows.Count} unattended day off record(s) to remove.";
                                btnRemove.Enabled = true;
                                ShowMessage($"Found {dt.Rows.Count} record(s) to remove", "success");
                            }
                            else
                            {
                                lblCount.Text = "No unattended day off records found for this employee.";
                                btnRemove.Enabled = false;
                                ShowMessage("No records to remove", "warning");
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"Error: {ex.Message}", "error");
            }
        }

        protected void btnRemove_Click(object sender, EventArgs e)
        {
            if (!int.TryParse(txtEmployeeID.Text.Trim(), out int employeeId))
            {
                ShowMessage("Please enter a valid Employee ID", "error");
                return;
            }

            try
            {
                string connectionString  = WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString();

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Execute the stored procedure
                    using (SqlCommand cmd = new SqlCommand("Remove_DayOff", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@employee_ID", employeeId);

                        int rowsAffected = cmd.ExecuteNonQuery();

                        ShowMessage($"✅ Successfully removed {rowsAffected} unattended day off record(s)", "success");

                        // Clear the grid and disable button
                        gvRecords.DataSource = null;
                        gvRecords.DataBind();
                        btnRemove.Enabled = false;
                        lblCount.Text = "Records have been removed.";
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"Error: {ex.Message}", "error");
            }
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