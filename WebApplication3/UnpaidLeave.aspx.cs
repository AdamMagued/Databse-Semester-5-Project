using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace WebApplication3
{
    public partial class UnpaidLeaveApproval : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                txtHRID.Text = Session["HR_ID"]?.ToString() ?? "4";
        }
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            resultContainer.Visible = false;

            if (!int.TryParse(txtRequestID.Text, out int reqID))
            {
                Show("ERROR", "Enter valid Request ID", "rejected");
                return;
            }

            if (!int.TryParse(txtHRID.Text, out int hrID))
            {
                Show("ERROR", "Enter valid HR ID", "rejected");
                return;
            }

            try
            {
                string connStr = @"Server=(localdb)\MSSQLLocalDB;Database=University_HR_ManagementSystem;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Check if it's unpaid leave
                    SqlCommand checkCmd = new SqlCommand(
                        "SELECT COUNT(*) FROM Unpaid_Leave WHERE request_ID = @id", conn);
                    checkCmd.Parameters.AddWithValue("@id", reqID);
                    int isUnpaid = (int)checkCmd.ExecuteScalar();

                    if (isUnpaid == 0)
                    {
                        Show("ERROR", "Not an unpaid leave request,enter an unpaid leave request", "rejected");
                        return;
                    }

                    // Process request
                    SqlCommand cmd = new SqlCommand("HR_approval_Unpaid", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@request_ID", reqID);
                    cmd.Parameters.AddWithValue("@HR_ID", hrID);
                    cmd.ExecuteNonQuery();

                    // Get result
                    checkCmd = new SqlCommand(
                        "SELECT final_approval_status FROM Leave WHERE request_ID = @id", conn);
                    checkCmd.Parameters.AddWithValue("@id", reqID);
                    string status = checkCmd.ExecuteScalar()?.ToString()?.ToLower() ?? "unknown";

                    // Show result
                    string displayStatus = status == "approved" ? "APPROVED" :
                                          status == "rejected" ? "REJECTED" :
                                          status.ToUpper();

                    Show(displayStatus, $"Request #{reqID}: {status}", status);
                }
            }
            catch (Exception ex)
            {
                Show("ERROR", ex.Message, "rejected");
            }
        }

        private void Show(string status, string reason, string type)
        {
            resultContainer.Visible = true;
            resultContainer.Attributes["class"] = "result-box " + type;
            lblStatus.Text = status;
            lblReason.Text = reason;
        }
    }
}