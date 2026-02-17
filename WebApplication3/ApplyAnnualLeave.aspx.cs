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
    public partial class ApplyAnnualLeave : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["employee_ID"] == null)
            {
                Response.Redirect("Login.aspx");
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString();

            int employeeID = Convert.ToInt32(Session["employee_ID"]);
            int replacementID;
            DateTime startDate, endDate;

            // Validate inputs
            if (!int.TryParse(txtReplacement.Text.Trim(), out replacementID))
            {
                lblMessage.Text = "Invalid replacement employee ID.";
                return;
            }

            if (!DateTime.TryParse(txtStartDate.Text, out startDate) ||
                !DateTime.TryParse(txtEndDate.Text, out endDate))
            {
                lblMessage.Text = "Please enter valid dates.";
                return;
            }

            // Call stored procedure
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("Submit_annual", conn);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@employee_ID", employeeID);
                cmd.Parameters.AddWithValue("@replacement_emp", replacementID);
                cmd.Parameters.AddWithValue("@start_date", startDate);
                cmd.Parameters.AddWithValue("@end_date", endDate);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();

                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    lblMessage.Text = "Annual leave submitted successfully!";
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Error: " + ex.Message;
                }
            }
        }
    }
}