using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication4.Admin
{
    public partial class SimpleRemoveApprovedLeaves : System.Web.UI.Page
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
                               dept_name
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

                    // 2. Get approved leaves for this employee
                    string leavesQuery = @"
                        SELECT 
                            'Annual Leave' as leave_type,
                            L.start_date,
                            L.end_date,
                            L.num_days,
                            L.date_of_request
                        FROM Leave L
                        INNER JOIN Annual_Leave AL ON L.request_ID = AL.request_ID
                        WHERE AL.emp_ID = @employeeId
                          AND L.final_approval_status = 'Approved'
                        
                        UNION ALL
                        
                        SELECT 
                            'Accidental Leave',
                            L.start_date,
                            L.end_date,
                            L.num_days,
                            L.date_of_request
                        FROM Leave L
                        INNER JOIN Accidental_Leave ACL ON L.request_ID = ACL.request_ID
                        WHERE ACL.emp_ID = @employeeId
                          AND L.final_approval_status = 'Approved'
                        
                        UNION ALL
                        
                        SELECT 
                            'Medical Leave',
                            L.start_date,
                            L.end_date,
                            L.num_days,
                            L.date_of_request
                        FROM Leave L
                        INNER JOIN Medical_Leave ML ON L.request_ID = ML.request_ID
                        WHERE ML.Emp_ID = @employeeId
                          AND L.final_approval_status = 'Approved'
                        
                        UNION ALL
                        
                        SELECT 
                            'Unpaid Leave',
                            L.start_date,
                            L.end_date,
                            L.num_days,
                            L.date_of_request
                        FROM Leave L
                        INNER JOIN Unpaid_Leave UL ON L.request_ID = UL.request_ID
                        WHERE UL.Emp_ID = @employeeId
                          AND L.final_approval_status = 'Approved'
                        
                        UNION ALL
                        
                        SELECT 
                            'Compensation Leave',
                            L.start_date,
                            L.end_date,
                            L.num_days,
                            L.date_of_request
                        FROM Leave L
                        INNER JOIN Compensation_Leave CL ON L.request_ID = CL.request_ID
                        WHERE CL.emp_ID = @employeeId
                          AND L.final_approval_status = 'Approved'
                        
                        ORDER BY start_date";

                    using (SqlCommand cmd = new SqlCommand(leavesQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@employeeId", employeeId);

                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            adapter.Fill(dt);

                            gvLeaves.DataSource = dt;
                            gvLeaves.DataBind();
                            lblLeaveCount.Text = dt.Rows.Count.ToString();
                        }
                    }

                    // 3. Get attendance records during approved leaves
                    string attendanceQuery = @"
                        SELECT 
                            A.date,
                            A.check_in_time,
                            A.check_out_time,
                            A.status,
                            CASE 
                                WHEN EXISTS (SELECT 1 FROM Leave L INNER JOIN Annual_Leave AL ON L.request_ID = AL.request_ID 
                                            WHERE AL.emp_ID = @employeeId AND L.final_approval_status = 'Approved' 
                                            AND A.date BETWEEN L.start_date AND L.end_date) THEN 'Annual Leave'
                                WHEN EXISTS (SELECT 1 FROM Leave L INNER JOIN Accidental_Leave ACL ON L.request_ID = ACL.request_ID 
                                            WHERE ACL.emp_ID = @employeeId AND L.final_approval_status = 'Approved' 
                                            AND A.date BETWEEN L.start_date AND L.end_date) THEN 'Accidental Leave'
                                WHEN EXISTS (SELECT 1 FROM Leave L INNER JOIN Medical_Leave ML ON L.request_ID = ML.request_ID 
                                            WHERE ML.Emp_ID = @employeeId AND L.final_approval_status = 'Approved' 
                                            AND A.date BETWEEN L.start_date AND L.end_date) THEN 'Medical Leave'
                                WHEN EXISTS (SELECT 1 FROM Leave L INNER JOIN Unpaid_Leave UL ON L.request_ID = UL.request_ID 
                                            WHERE UL.Emp_ID = @employeeId AND L.final_approval_status = 'Approved' 
                                            AND A.date BETWEEN L.start_date AND L.end_date) THEN 'Unpaid Leave'
                                WHEN EXISTS (SELECT 1 FROM Leave L INNER JOIN Compensation_Leave CL ON L.request_ID = CL.request_ID 
                                            WHERE CL.emp_ID = @employeeId AND L.final_approval_status = 'Approved' 
                                            AND A.date BETWEEN L.start_date AND L.end_date) THEN 'Compensation Leave'
                                ELSE 'Other'
                            END as leave_type
                        FROM Attendance A
                        WHERE A.emp_ID = @employeeId
                          AND (
                            -- Check if date falls within any approved leave
                            EXISTS (SELECT 1 FROM Leave L INNER JOIN Annual_Leave AL ON L.request_ID = AL.request_ID 
                                   WHERE AL.emp_ID = @employeeId AND L.final_approval_status = 'Approved' 
                                   AND A.date BETWEEN L.start_date AND L.end_date)
                            OR
                            EXISTS (SELECT 1 FROM Leave L INNER JOIN Accidental_Leave ACL ON L.request_ID = ACL.request_ID 
                                   WHERE ACL.emp_ID = @employeeId AND L.final_approval_status = 'Approved' 
                                   AND A.date BETWEEN L.start_date AND L.end_date)
                            OR
                            EXISTS (SELECT 1 FROM Leave L INNER JOIN Medical_Leave ML ON L.request_ID = ML.request_ID 
                                   WHERE ML.Emp_ID = @employeeId AND L.final_approval_status = 'Approved' 
                                   AND A.date BETWEEN L.start_date AND L.end_date)
                            OR
                            EXISTS (SELECT 1 FROM Leave L INNER JOIN Unpaid_Leave UL ON L.request_ID = UL.request_ID 
                                   WHERE UL.Emp_ID = @employeeId AND L.final_approval_status = 'Approved' 
                                   AND A.date BETWEEN L.start_date AND L.end_date)
                            OR
                            EXISTS (SELECT 1 FROM Leave L INNER JOIN Compensation_Leave CL ON L.request_ID = CL.request_ID 
                                   WHERE CL.emp_ID = @employeeId AND L.final_approval_status = 'Approved' 
                                   AND A.date BETWEEN L.start_date AND L.end_date)
                          )
                          -- Only show records that would be deleted (absent/unattended)
                          AND (
                            (A.status IS NOT NULL AND UPPER(A.status) = 'ABSENT')
                            OR (A.check_in_time IS NULL AND A.check_out_time IS NULL)
                          )
                        ORDER BY A.date";

                    using (SqlCommand cmd = new SqlCommand(attendanceQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@employeeId", employeeId);

                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            adapter.Fill(dt);

                            gvAttendance.DataSource = dt;
                            gvAttendance.DataBind();

                            // Update count and enable button
                            if (dt.Rows.Count > 0)
                            {
                                lblAttendanceCount.Text = $"Found {dt.Rows.Count} attendance record(s) during approved leaves to remove.";
                                btnRemove.Enabled = true;
                                ShowMessage($"Found {dt.Rows.Count} record(s) to remove", "info");
                            }
                            else
                            {
                                lblAttendanceCount.Text = "No attendance records found during approved leaves.";
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
                string connectionString = WebConfigurationManager.ConnectionStrings["University_HR_ManagementSystem"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Execute the stored procedure
                    using (SqlCommand cmd = new SqlCommand("Remove_Approved_Leaves", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@employee_id", employeeId);

                        int rowsAffected = cmd.ExecuteNonQuery();

                        ShowMessage($"✅ Successfully removed {rowsAffected} attendance record(s) during approved leaves", "success");

                        // Clear the grids and disable button
                        gvAttendance.DataSource = null;
                        gvAttendance.DataBind();
                        btnRemove.Enabled = false;
                        lblAttendanceCount.Text = "Records have been removed.";
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