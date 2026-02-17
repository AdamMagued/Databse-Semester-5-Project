using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace WebApplication3
{
    public partial class LeaveApproval : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                txtHRID.Text = Session["HR_ID"]?.ToString() ?? "4";
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            // Hide result initially
            lblResult.Visible = false;

            if (!int.TryParse(txtRequestID.Text, out int reqID))
            {
                Show("ERROR", "Enter valid Request ID", "error");
                return;
            }

            if (!int.TryParse(txtHRID.Text, out int hrID))
            {
                Show("ERROR", "Enter valid HR ID", "error");
                return;
            }

            try
            {
                string connStr = @"Server=(localdb)\MSSQLLocalDB;Database=University_HR_ManagementSystem;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();


                    // Check if it's in either Accidental_Leave OR Annual_Leave table
                    SqlCommand checkCmd = new SqlCommand(
                        @"SELECT 
                    CASE 
                        WHEN EXISTS (SELECT 1 FROM Accidental_Leave WHERE request_ID = @id) THEN 'accidental'
                        WHEN EXISTS (SELECT 1 FROM Annual_Leave WHERE request_ID = @id) THEN 'annual'
                        ELSE 'not_found'
                    END as leave_type", conn);
                    checkCmd.Parameters.AddWithValue("@id", reqID);
                    string leaveType = checkCmd.ExecuteScalar()?.ToString();

                    if (leaveType == "not_found")
                    {
                        Show("ERROR", "Leave request not found in Accidental or Annual leave tables, enter accidental or annual leave request", "error");
                        return;
                    }


                    // Process request using stored procedure HR_approval_an_acc
                    using (SqlCommand cmd = new SqlCommand("HR_approval_an_acc", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@request_ID", reqID);
                        cmd.Parameters.AddWithValue("@HR_ID", hrID);
                        cmd.ExecuteNonQuery();
                    }

                    // Get result from database
                    checkCmd = new SqlCommand(
                        "SELECT final_approval_status FROM Leave WHERE request_ID = @id", conn);
                    checkCmd.Parameters.AddWithValue("@id", reqID);
                    string status = checkCmd.ExecuteScalar()?.ToString()?.ToLower() ?? "unknown";

                    // Show result
                    string displayStatus = status == "approved" ? "APPROVED" :
                                          status == "rejected" ? "REJECTED" :
                                          status.ToUpper();

                    Show(displayStatus, $"Request #{reqID} {status}", status);
                }
            }
            catch (Exception ex)
            {
                Show("ERROR", ex.Message, "error");
            }
        }

        private void Show(string status, string reason, string type)
        {
            lblResult.Visible = true;

            // Set CSS class based on type
            if (type == "approved")
            {
                lblResult.CssClass = "result-message result-success";
            }
            else if (type == "rejected")
            {
                lblResult.CssClass = "result-message result-error";
            }
            else // error or unknown
            {
                lblResult.CssClass = "result-message result-error";
            }

            lblResult.Text = $"{status}: {reason}";
        }
    }
}