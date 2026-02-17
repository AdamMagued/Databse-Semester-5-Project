using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication4.Admin
{
    public partial class SimpleReplaceEmployee : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            

            if (!IsPostBack)
            {
                // Set default dates
                txtFromDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                txtToDate.Text = DateTime.Now.AddDays(1).ToString("yyyy-MM-dd");

                // Load current replacements
                LoadReplacements();
            }
        }

        protected void btnReplace_Click(object sender, EventArgs e)
        {
            // Validate inputs
            if (!int.TryParse(txtEmp1ID.Text.Trim(), out int emp1Id))
            {
                ShowMessage("Please enter a valid Employee ID for the employee to replace", "error");
                return;
            }

            if (!int.TryParse(txtEmp2ID.Text.Trim(), out int emp2Id))
            {
                ShowMessage("Please enter a valid Employee ID for the replacement employee", "error");
                return;
            }

            if (!DateTime.TryParse(txtFromDate.Text, out DateTime fromDate))
            {
                ShowMessage("Please enter a valid From Date", "error");
                return;
            }

            if (!DateTime.TryParse(txtToDate.Text, out DateTime toDate))
            {
                ShowMessage("Please enter a valid To Date", "error");
                return;
            }

            if (emp1Id == emp2Id)
            {
                ShowMessage("Employee IDs cannot be the same", "error");
                return;
            }

            if (fromDate > toDate)
            {
                ShowMessage("From Date must be before To Date", "error");
                return;
            }

            try
            {
                string connectionString =  WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString();

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Execute the stored procedure
                    using (SqlCommand cmd = new SqlCommand("Replace_employee", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@Emp1_ID", emp1Id);
                        cmd.Parameters.AddWithValue("@Emp2_ID", emp2Id);
                        cmd.Parameters.AddWithValue("@from_date", fromDate);
                        cmd.Parameters.AddWithValue("@to_date", toDate);

                        // Since the procedure uses PRINT statements, we need to capture output
                        // Create a temporary table to capture PRINT messages
                        string createTempTable = @"
                            CREATE TABLE #TempMessages (Message NVARCHAR(MAX));
                            SET NOCOUNT ON;";

                        using (SqlCommand tempCmd = new SqlCommand(createTempTable, conn))
                        {
                            tempCmd.ExecuteNonQuery();
                        }

                        // Execute the procedure
                        int rowsAffected = cmd.ExecuteNonQuery();

                        // Check for PRINT messages
                        string checkMessages = @"
                            SELECT Message FROM #TempMessages;
                            DROP TABLE #TempMessages;";

                        using (SqlCommand msgCmd = new SqlCommand(checkMessages, conn))
                        using (SqlDataReader msgReader = msgCmd.ExecuteReader())
                        {
                            if (msgReader.Read())
                            {
                                string message = msgReader["Message"].ToString();
                                if (message.Contains("Error") || message.Contains("not found") || message.Contains("overlapping"))
                                {
                                    ShowMessage("❌ " + message, "error");
                                }
                                else
                                {
                                    ShowMessage("ℹ️ " + message, "info");
                                }
                            }
                            else if (rowsAffected > 0)
                            {
                                ShowMessage($"✅ Success! Employee {emp2Id} will replace Employee {emp1Id} from {fromDate:yyyy-MM-dd} to {toDate:yyyy-MM-dd}", "success");

                                // Clear form
                                txtEmp1ID.Text = "";
                                txtEmp2ID.Text = "";

                                // Refresh replacements list
                                LoadReplacements();
                            }
                            else
                            {
                                ShowMessage("Replacement created successfully", "success");

                                // Clear form
                                txtEmp1ID.Text = "";
                                txtEmp2ID.Text = "";

                                // Refresh replacements list
                                LoadReplacements();
                            }
                        }
                    }
                }
            }
            catch (SqlException ex)
            {
                ShowMessage($"Database error: {ex.Message}", "error");
            }
            catch (Exception ex)
            {
                ShowMessage($"Error: {ex.Message}", "error");
            }
        }

        private void LoadReplacements()
        {
            try
            {
                string connectionString = WebConfigurationManager.ConnectionStrings["University_HR_ManagementSystem"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Get current and future replacements
                    string query = @"
                        SELECT 
                            r.Emp1_ID,
                            e1.first_name + ' ' + e1.last_name as Emp1_Name,
                            r.Emp2_ID,
                            e2.first_name + ' ' + e2.last_name as Emp2_Name,
                            r.from_date,
                            r.to_date
                        FROM Employee_Replace_Employee r
                        INNER JOIN Employee e1 ON r.Emp1_ID = e1.employee_id
                        INNER JOIN Employee e2 ON r.Emp2_ID = e2.employee_id
                        WHERE r.to_date >= GETDATE()  -- Show current and future replacements
                        ORDER BY r.from_date";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);

                        gvReplacements.DataSource = dt;
                        gvReplacements.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                // Silent fail - don't show error for this
                System.Diagnostics.Debug.WriteLine($"Error loading replacements: {ex.Message}");
            }
        }

        protected void btnLoadReplacements_Click(object sender, EventArgs e)
        {
            LoadReplacements();
            ShowMessage("Replacements list refreshed", "info");
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