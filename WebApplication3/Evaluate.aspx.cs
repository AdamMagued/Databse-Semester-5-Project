using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace WebApplication1
{
    public partial class Evaluate : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["employee_ID"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            else if (!IsPostBack)
            {
                // 1. SECURITY CHECK: Verify the user is a Dean
                if (IsDean(Convert.ToInt32(Session["employee_ID"])))
                {
                    LoadEmployeeList();
                }
                else
                {
                    // Block access
                    lblMsg.Text = "ACCESS DENIED: Only Deans can perform evaluations.";
                    lblMsg.ForeColor = System.Drawing.Color.Red;
                    btnEvaluate.Visible = false;
                    ddlEmployees.Visible = false;
                    txtScore.Visible = false;
                    txtComment.Visible = false;
                }
            }
        }

        // Helper to check if the user has the 'Dean' role
        private bool IsDean(int empId)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // We check the Employee_Role table directly
                string query = "SELECT COUNT(*) FROM Employee_Role WHERE emp_ID = @id AND role_name = 'Dean'";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.Add(new SqlParameter("@id", empId));
                conn.Open();
                int count = (int)cmd.ExecuteScalar();
                conn.Close();
                return count > 0;
            }
        }

        protected void LoadEmployeeList()
        {
            string connStr = WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // NOTE: We MUST use this raw SQL because the provided SQL script 
                // does not have a Stored Procedure to "Get Employees by Department".
                string query = @"
                    SELECT employee_id, first_name + ' ' + last_name AS name 
                    FROM Employee 
                    WHERE dept_name = (SELECT dept_name FROM Employee WHERE employee_id = @dean_id) 
                    AND employee_id <> @dean_id";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.CommandType = System.Data.CommandType.Text;
                cmd.Parameters.Add(new SqlParameter("@dean_id", Convert.ToInt32(Session["employee_ID"])));

                conn.Open();

                ddlEmployees.DataSource = cmd.ExecuteReader();
                ddlEmployees.DataTextField = "name";
                ddlEmployees.DataValueField = "employee_id";
                ddlEmployees.DataBind();

                conn.Close();
            }
        }

        protected void btnEvaluate_Click(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString();
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("Dean_andHR_Evaluation", conn);
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@employee_ID", ddlEmployees.SelectedValue));
                    cmd.Parameters.Add(new SqlParameter("@rating", txtScore.Text));
                    cmd.Parameters.Add(new SqlParameter("@comment", txtComment.Text));
                    cmd.Parameters.Add(new SqlParameter("@semester", "W25"));

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();

                    lblMsg.Text = "Evaluation submitted successfully!";
                    lblMsg.ForeColor = System.Drawing.Color.Green;
                }
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Error: " + ex.Message;
                lblMsg.ForeColor = System.Drawing.Color.Red;
            }
        }
    }
}