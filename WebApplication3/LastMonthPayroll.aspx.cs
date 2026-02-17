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
    public partial class LastMonthPayroll : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["employee_ID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }
        }

        protected void btnGetPayroll_Click(object sender, EventArgs e)
        {
            int employee_ID = Convert.ToInt32(Session["employee_ID"]);
            string connStr = WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT * FROM Last_month_payroll(@employee_ID)";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@employee_ID", employee_ID);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                GridViewPayroll.DataSource = reader;
                GridViewPayroll.DataBind();

                conn.Close();
            }
        }
    }
}