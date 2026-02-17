using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class StatusLeaves : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["employee_ID"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                LoadLeaveStatus();
            }
        }

        private void LoadLeaveStatus()
        {
            int employeeId = Convert.ToInt32(Session["employee_ID"]);
            string connString = WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString();

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT * FROM Status_leaves(@employee_ID)";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@employee_ID", employeeId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                GridViewStatusLeaves.DataSource = reader;
                GridViewStatusLeaves.DataBind();
            }
        }
    }
}