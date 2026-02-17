using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class DeductionsAttendance : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnFetch_Click(object sender, EventArgs e)
        {
            if (Session["employee_ID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            int employee_ID = Convert.ToInt32(Session["employee_ID"]);
            int month = int.Parse(txtMonth.Text.Trim());

            string connStr = WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT * FROM dbo.Deductions_Attendance(@employee_ID, @month)";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@employee_ID", employee_ID);
                    cmd.Parameters.AddWithValue("@month", month);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    GridViewDeductions.DataSource = reader;
                    GridViewDeductions.DataBind();

                    conn.Close();
                }
            }
        }
    }
}