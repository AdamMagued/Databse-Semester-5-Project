using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI;

namespace WebApplication3
{
    public partial class Monthly_Payroll : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Set default dates to current month
                DateTime firstDay = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                DateTime lastDay = firstDay.AddMonths(1).AddDays(-1);
                
                txtFromDate.Text = firstDay.ToString("yyyy-MM-dd");
                txtToDate.Text = lastDay.ToString("yyyy-MM-dd");
            }
        }

        protected void btnGenerate_Click(object sender, EventArgs e)
        {
            // Clear previous results
            lblResult.Visible = false;
            lblResult.CssClass = "";
            lblResult.Text = "";
            
            payrollDetails.Visible = false;

            // 1. Validate Employee ID
            if (!int.TryParse(txtEmployeeID.Text.Trim(), out int employeeID) || employeeID <= 0)
            {
                ShowMessage("Please enter a valid Employee ID", "error");
                return;
            }

            // 2. Validate dates
            if (!DateTime.TryParse(txtFromDate.Text.Trim(), out DateTime fromDate))
            {
                ShowMessage("Please enter a valid From Date", "error");
                return;
            }


            if (!DateTime.TryParse(txtToDate.Text.Trim(), out DateTime toDate))
            {
                ShowMessage("Please enter a valid To Date", "error");
                return;
            }
            if (fromDate.Month != toDate.Month || fromDate.Year != toDate.Year)
            {
                ShowMessage("Payroll period must be within the same calendar month", "error");
                return;
            }
            
            // 3. Check if from date is before to date
            if (fromDate > toDate)
            {
                ShowMessage("From Date must be before To Date", "error");
                return;
            }
            // Check if it's entire month (1st to last day)
            DateTime firstDayOfMonth = new DateTime(fromDate.Year, fromDate.Month, 1);
            DateTime lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);

            if (fromDate != firstDayOfMonth || toDate != lastDayOfMonth)
            {
                ShowMessage("Payroll can only be processed for entire months (1st to last day)", "error");
                return;
            }

            // 4. Get connection string
            string connStr = WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"]?.ToString();
            if (string.IsNullOrEmpty(connStr))
            {
                ShowMessage("Database connection error. Please contact administrator.", "error");
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    // 5. First check if employee exists
                    bool employeeExists = false;
                    string employeeName = "";
                    
                    using (SqlCommand checkCmd = new SqlCommand(
                        "SELECT employee_id, first_name + ' ' + last_name as full_name FROM Employee WHERE employee_id = @empID", conn))
                    {
                        checkCmd.Parameters.AddWithValue("@empID", employeeID);
                        conn.Open();
                        
                        using (SqlDataReader reader = checkCmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                employeeExists = true;
                                employeeName = reader["full_name"].ToString();
                            }
                        }
                    }

                    if (!employeeExists)
                    {
                        ShowMessage($"Employee with ID {employeeID} not found.", "error");
                        return;
                    }

                    // 6. Call the Add_Payroll stored procedure
                    using (SqlCommand cmd = new SqlCommand("Add_Payroll", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@employee_ID", employeeID);
                        cmd.Parameters.AddWithValue("@from", fromDate);
                        cmd.Parameters.AddWithValue("@to", toDate);
                        
                        cmd.ExecuteNonQuery();
                    }

                    // 7. Get the generated payroll details
                    using (SqlCommand getPayrollCmd = new SqlCommand(
                        @"SELECT TOP 1 
                            p.payment_date,
                            p.final_salary_amount,
                            p.from_date,
                            p.to_date,
                            p.comments,
                            p.bonus_amount,
                            p.deductions_amount,
                            e.salary as base_salary,
                            e.first_name + ' ' + e.last_name as employee_name
                          FROM Payroll p
                          INNER JOIN Employee e ON p.emp_ID = e.employee_id
                          WHERE p.emp_ID = @empID 
                          ORDER BY p.payment_date DESC", conn))
                    {
                        getPayrollCmd.Parameters.AddWithValue("@empID", employeeID);
                        
                        using (SqlDataReader reader = getPayrollCmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                // 8. Display payroll details
                                empName.InnerText = reader["employee_name"].ToString();
                                payPeriod.InnerText = $"{Convert.ToDateTime(reader["from_date"]):dd/MM/yyyy} to {Convert.ToDateTime(reader["to_date"]):dd/MM/yyyy}";
                                baseSalary.InnerText = $"${Convert.ToDecimal(reader["base_salary"]):F2}";
                                bonusAmount.InnerText = $"${Convert.ToDecimal(reader["bonus_amount"]):F2}";
                                deductions.InnerText = $"${Convert.ToDecimal(reader["deductions_amount"]):F2}";
                                comments.InnerText = reader["comments"].ToString();
                                finalSalary.InnerText = $"${Convert.ToDecimal(reader["final_salary_amount"]):F2}";
                                generatedDate.InnerText = Convert.ToDateTime(reader["payment_date"]).ToString("dd/MM/yyyy HH:mm");
                                
                                payrollDetails.Visible = true;
                            }
                        }
                    }

                    // 9. Show success message
                    ShowMessage($"Payroll successfully generated for {employeeName} (ID: {employeeID})", "success");
                }
            }
            catch (SqlException sqlEx)
            {
                ShowMessage($"Database error: {sqlEx.Message}", "error");
            }
            catch (Exception ex)
            {
                ShowMessage($"Error: {ex.Message}", "error");
            }
        }

        private void ShowMessage(string message, string messageType)
        {
            lblResult.Text = message;
            lblResult.CssClass = $"message {messageType}";
            lblResult.Visible = true;
        }
    }
}