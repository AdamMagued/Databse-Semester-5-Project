using System;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace WebApplication3
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Optional: clear session or other init logic
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            int employeeID;
            string password = txtPassword.Text.Trim();

            if (!int.TryParse(txtUsername.Text.Trim(), out employeeID))
            {
                return;
            }

            string connStr = WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT dbo.HRLoginValidation(@employee_ID, @password)";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@employee_ID", employeeID);
                    cmd.Parameters.AddWithValue("@password", password);

                    conn.Open();

                    object result = cmd.ExecuteScalar();
                    int success = (result != DBNull.Value) ? Convert.ToInt32(result) : 0;
                    if (employeeID == 100 && password == "admin123")
                    {
                        Session["Admin_ID"] = "admin";
                        Response.Redirect("System/Admin/AdminDashboard.aspx"); ;
                        return;
                    }

                    if (success == 1)
                    {
                        // Just use the employee ID they logged in with
                        Session["HR_ID"] = employeeID.ToString();
                        Response.Redirect("HR_Dashboard.aspx");
                    }
                    else
                    {
                        string query2 = "SELECT dbo.EmployeeLoginValidation(@employee_ID, @password)";
                        using (SqlCommand cmd2 = new SqlCommand(query2, conn))
                        {
                            cmd2.Parameters.AddWithValue("@employee_ID", employeeID);
                            cmd2.Parameters.AddWithValue("@password", password);

                            object result2 = cmd2.ExecuteScalar();
                            int isEmployee = (result2 != DBNull.Value) ? Convert.ToInt32(result2) : 0;

                            if (isEmployee == 1)
                            {
                                Session["Employee_ID"] = employeeID.ToString();
                                Response.Redirect("MainMenu.aspx");
                            }
                            else
                            {
                                Response.Write("<script>alert('Invalid Employee ID or Password');</script>");
                            }
                        }
                    }
                    
                }
            }
        }
    }
}
