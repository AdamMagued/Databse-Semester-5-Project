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
    public partial class Attendance : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAttendance();
            }
        }

        private void LoadAttendance()
        {
            if (Session["employee_ID"] == null)
            {
                Response.Redirect("Login.aspx"); // Ensure user is logged in
                return;
            }

            int employee_ID = Convert.ToInt32(Session["employee_ID"]);
            string connStr = WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT * FROM dbo.MyAttendance(@employee_ID)";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@employee_ID", employee_ID);
                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        GridViewAttendance.DataSource = reader;
                        GridViewAttendance.DataBind();
                    }

                    conn.Close();
                }
            }
        }
    }
}