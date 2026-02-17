using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace PayrollSystem
{
    public partial class DeductHours : Page
    {
        string connectionString = @"Server=(localdb)\MSSQLLocalDB;Database=University_HR_ManagementSystem;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnHours_Click(object sender, EventArgs e)
        {
            CalculateDeduction("Deduction_hours", "Missing hours");
        }

        protected void btnDays_Click(object sender, EventArgs e)
        {
            CalculateDeduction("Deduction_days", "Missing days");
        }

        protected void btnUnpaid_Click(object sender, EventArgs e)
        {
            CalculateDeduction("Deduction_unpaid", "Unpaid leave");
        }

        private void CalculateDeduction(string procedureName, string deductionType)
        {
            // Clear previous result
            lblResult.Text = "";

            // Get employee ID from textbox
            if (string.IsNullOrEmpty(txtEmployeeID.Text))
            {
                lblResult.Text = "Please enter Employee ID";
                return;
            }

            int employeeID;
            if (!int.TryParse(txtEmployeeID.Text, out employeeID))
            {
                lblResult.Text = "Please enter a valid Employee ID number";
                return;
            }

            try
            {
                // Check if employee exists
                using (SqlConnection checkConn = new SqlConnection(connectionString))
                {
                    string checkQuery = "SELECT COUNT(*) FROM Employee WHERE employee_id = @employee_ID";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, checkConn))
                    {
                        checkCmd.Parameters.AddWithValue("@employee_ID", employeeID);
                        checkConn.Open();
                        int count = (int)checkCmd.ExecuteScalar();

                        if (count == 0)
                        {
                            lblResult.Text = $"Employee ID {employeeID} does not exist. Please enter a valid Employee ID.";
                            return;
                        }
                    }
                }

                // Get count of existing PENDING deductions BEFORE running procedure
                int existingPendingCount = 0;
                using (SqlConnection checkBeforeConn = new SqlConnection(connectionString))
                {
                    string checkBeforeQuery = "SELECT COUNT(*) FROM Deduction WHERE emp_ID = @employee_ID AND status = 'Pending'";
                    using (SqlCommand checkBeforeCmd = new SqlCommand(checkBeforeQuery, checkBeforeConn))
                    {
                        checkBeforeCmd.Parameters.AddWithValue("@employee_ID", employeeID);
                        checkBeforeConn.Open();
                        existingPendingCount = (int)checkBeforeCmd.ExecuteScalar();
                    }
                }

                // Call the stored procedure
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(procedureName, conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@employee_ID", employeeID);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                // Get count of PENDING deductions AFTER running procedure
                int newPendingCount = 0;
                using (SqlConnection checkAfterConn = new SqlConnection(connectionString))
                {
                    string checkAfterQuery = "SELECT COUNT(*) FROM Deduction WHERE emp_ID = @employee_ID AND status = 'Pending'";
                    using (SqlCommand checkAfterCmd = new SqlCommand(checkAfterQuery, checkAfterConn))
                    {
                        checkAfterCmd.Parameters.AddWithValue("@employee_ID", employeeID);
                        checkAfterConn.Open();
                        newPendingCount = (int)checkAfterCmd.ExecuteScalar();
                    }
                }

                // Calculate how many new deductions were added
                int newlyAddedCount = newPendingCount - existingPendingCount;

                // Show appropriate message
                if (newlyAddedCount > 0)
                {
                    lblResult.Text = $"{deductionType} deduction calculated successfully for Employee ID: {employeeID}. {newlyAddedCount} new deduction(s) added .";
                }
                else if (newPendingCount > 0 && newlyAddedCount == 0)
                {
                    lblResult.Text = $"No new {deductionType} deductions added for Employee ID: {employeeID}.";
                }
                else
                {
                    lblResult.Text = $"No {deductionType} deductions were added for Employee ID: {employeeID}. Employee may not have any missing hours/days/unpaid leave.";
                }
            }
            catch (Exception ex)
            {
                lblResult.Text = "Error: " + ex.Message;
            }
        }
    }
}
          