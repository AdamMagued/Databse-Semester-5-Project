using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class EmployeePerformance : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if employee is logged in
            if (Session["employee_ID"] == null)
            {
                Response.Redirect("Login.aspx");
            }
        }

        protected void RetrieveButton_Click(object sender, EventArgs e)
        {
            int employee_ID = Convert.ToInt32(Session["employee_ID"]); // get ID from session
            string semester = SemesterTextBox.Text.Trim();

            if (string.IsNullOrEmpty(semester))
            {
                MessageLabel.Text = "Please enter a semester.";
                return;
            }

            string connStr = WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT * FROM dbo.MyPerformance(@employee_ID, @semester)";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@employee_ID", employee_ID);
                    cmd.Parameters.AddWithValue("@semester", semester);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        PerformanceGridView.DataSource = dt;
                        PerformanceGridView.DataBind();
                        MessageLabel.Text = "";
                    }
                    else
                    {
                        PerformanceGridView.DataSource = null;
                        PerformanceGridView.DataBind();
                        MessageLabel.Text = "No performance records found for this semester.";
                    }
                }
            }
        }
    }
}