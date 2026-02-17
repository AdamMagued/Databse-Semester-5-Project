using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;

namespace WebApplication1
{
    public partial class adminpage : System.Web.UI.Page
    {
        string connStr = WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Clear message on initial load
            if (!IsPostBack)
            {
                lblMessage.Visible = false;
            }
        }

        // --- Helper Method to Show Messages ---
        private void ShowAlert(string message, bool isError)
        {
            lblMessage.Visible = true;
            lblMessage.Text = isError ? $"❌ Error: {message}" : $"✅ {message}";
            lblMessage.CssClass = isError ? "alert alert-danger" : "alert alert-success";
        }

        // 2) View Employee Profiles
        protected void btnProfiles_Click(object sender, EventArgs e)
        {
            Display("SELECT * FROM allEmployeeProfiles", "Employee profiles loaded successfully.");
        }

        // 3) Employees per department
        protected void btnDeptCount_Click(object sender, EventArgs e)
        {
            Display("SELECT * FROM NoEmployeeDept", "Department counts loaded successfully.");
        }

        // 4) Rejected medical leaves
        protected void btnRejected_Click(object sender, EventArgs e)
        {
            Display("SELECT * FROM allRejectedMedicals", "Rejected medical leaves loaded.");
        }

        // 5) Remove deductions of resigned employees
        protected void btnRemoveDeductions_Click(object sender, EventArgs e)
        {
            ExecuteStored("Remove_Deductions", "Deductions for resigned employees removed successfully.");
        }

        // 6) Update attendance of specific employee
        protected void btnUpdateAttendance_Click(object sender, EventArgs e)
        {

            {
                // Input Validation
                if (string.IsNullOrWhiteSpace(txtEmpID_Att.Text))
                {
                    ShowAlert("Please enter an Employee ID.", true);
                    return;
                }

                try
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        SqlCommand cmd = new SqlCommand("Update_Attendance", conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.AddWithValue("@Employee_id", int.Parse(txtEmpID_Att.Text));

                        if (string.IsNullOrWhiteSpace(txtCheckIn.Text))
                            cmd.Parameters.AddWithValue("@check_in_time", DBNull.Value);
                        else
                            cmd.Parameters.AddWithValue("@check_in_time", TimeSpan.Parse(txtCheckIn.Text));

                        if (string.IsNullOrWhiteSpace(txtCheckOut.Text))
                            cmd.Parameters.AddWithValue("@check_out_time", DBNull.Value);
                        else
                            cmd.Parameters.AddWithValue("@check_out_time", TimeSpan.Parse(txtCheckOut.Text));

                        conn.Open();
                        string dbErrorMessage = "";

                        // Subscribe to capture PRINT messages
                        conn.InfoMessage += (object obj, SqlInfoMessageEventArgs args) =>
                        {
                            dbErrorMessage += args.Message;
                        };


                        // Capture the number of rows affected
                        int rowsAffected = cmd.ExecuteNonQuery();

                        // CHECK: If 0 rows were updated, it means the IF condition in SQL failed
                        if (rowsAffected > 0)
                        {
                            ShowAlert("Attendance updated successfully.", false);
                        }
                        else
                        {
                            if (!string.IsNullOrEmpty(dbErrorMessage))
                            {
                                ShowAlert(dbErrorMessage, true);
                            }
                            else
                            {
                                ShowAlert("Could not update attendance record holiday. Please check inputs.", true);
                            }
                        }
                    }
                }
                catch (FormatException)
                {
                    ShowAlert("Invalid time format. Please use HH:mm (e.g., 09:00).", true);
                }
                catch (SqlException ex)
                {
                    ShowAlert(ex.Message, true);
                }
                catch (Exception ex)
                {
                    ShowAlert(ex.Message, true);
                }
            }
        }


        // 7) Add new Holiday
        protected void btnAddHoliday_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtHolidayName.Text) ||
                string.IsNullOrWhiteSpace(txtFromDate.Text) ||
                string.IsNullOrWhiteSpace(txtToDate.Text))
            {
                ShowAlert("Please fill in all Holiday fields.", true);
                return;
            }

            DateTime fromDate;
            DateTime toDate;
            bool isFromValid = DateTime.TryParse(txtFromDate.Text, out fromDate);
            bool isToValid = DateTime.TryParse(txtToDate.Text, out toDate);

            if (!isFromValid || !isToValid)
            {
                ShowAlert("Invalid date format. Please use YYYY-MM-DD.", true);
                return;
            }

            // Check if From Date is after To Date
            if (fromDate > toDate)
            {
                ShowAlert("The 'From Date' cannot be later than the 'To Date'.", true);
                return; // Stop here. Do not call the database.
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    string dbErrorMessage = "";

                    // Subscribe to capture PRINT messages
                    conn.InfoMessage += (object obj, SqlInfoMessageEventArgs args) =>
                    {
                        dbErrorMessage += args.Message;
                    };

                    // Step 1: Ensure table exists
                    SqlCommand createHolidayCmd = new SqlCommand("Create_Holiday", conn);
                    createHolidayCmd.CommandType = CommandType.StoredProcedure;
                    createHolidayCmd.ExecuteNonQuery();

                    // *** FIX: Clear the message variable here ***
                    // This removes "There is already Holiday table in the database"
                    dbErrorMessage = "";

                    // Step 2: Add the holiday
                    SqlCommand cmd = new SqlCommand("Add_Holiday", conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@holiday_name", txtHolidayName.Text);
                    cmd.Parameters.AddWithValue("@from_date", DateTime.Parse(txtFromDate.Text));
                    cmd.Parameters.AddWithValue("@to_date", DateTime.Parse(txtToDate.Text));

                    int rowsAffected = cmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        ShowAlert($"Holiday '{txtHolidayName.Text}' added successfully.", false);
                    }
                    else
                    {
                        if (!string.IsNullOrEmpty(dbErrorMessage))
                        {
                            ShowAlert(dbErrorMessage, true);
                        }
                        else
                        {
                            ShowAlert("Could not add holiday. Please check inputs.", true);
                        }
                    }
                }
            }
            catch (FormatException)
            {
                ShowAlert("Invalid date format. Please use YYYY-MM-DD.", true);
            }
            catch (SqlException ex)
            {
                ShowAlert("Database Error: " + ex.Message, true);
            }
            catch (Exception ex)
            {
                ShowAlert("Error: " + ex.Message, true);
            }
        }

        // 8) Initiate Attendance for all employees
        protected void btnInitiateAttendance_Click(object sender, EventArgs e)
        {
            ExecuteStored("Initiate_Attendance", "Attendance initiated for all employees.");
        }



        // Updated Display method to handle errors
        private void Display(string query, string successMessage)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter(query, conn);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    GridView1.DataSource = dt;
                    GridView1.DataBind();

                    if (dt.Rows.Count == 0)
                    {
                        ShowAlert("Query executed successfully, but no records were found.", false);
                    }
                    else
                    {
                        ShowAlert(successMessage, false);
                    }
                }
            }
            catch (SqlException ex)
            {
                ShowAlert("Database Error: " + ex.Message, true);
                GridView1.DataSource = null;
                GridView1.DataBind();
            }
            catch (Exception ex)
            {
                ShowAlert("Error: " + ex.Message, true);
            }
        }

        // Updated ExecuteStored method to handle errors
        private void ExecuteStored(string procName, string successMessage)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(procName, conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    ShowAlert(successMessage, false);
                }
            }
            catch (SqlException ex)
            {
                ShowAlert("Database Error: " + ex.Message, true);
            }
            catch (Exception ex)
            {
                ShowAlert("Error: " + ex.Message, true);
            }
        }
    }
}