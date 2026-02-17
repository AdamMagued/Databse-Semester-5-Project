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
    public partial class ApplyLeave : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Updated to check friend's session variable
            if (Session["employee_ID"] == null)
            {
                Response.Redirect("Login.aspx");
            }
        }

        protected void ddlLeaveType_SelectedIndexChanged(object sender, EventArgs e)
        {
            string type = ddlLeaveType.SelectedValue;
            pnlReplacement.Visible = (type == "compensation");
            pnlCompensation.Visible = (type == "compensation");
        }

        protected void btnApply_Click(object sender, EventArgs e)
        {
            // Updated Connection String
            string connStr = WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString();
            string type = ddlLeaveType.SelectedValue;
            string procName = "";

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand();
                    cmd.Connection = conn;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    if (type == "accidental")
                    {
                        procName = "Submit_accidental";
                        // Changed Session["user_id"] to Session["employee_ID"]
                        cmd.Parameters.Add(new SqlParameter("@employee_ID", Session["employee_ID"]));
                        cmd.Parameters.Add(new SqlParameter("@start_date", txtStartDate.Text));
                        cmd.Parameters.Add(new SqlParameter("@end_date", txtEndDate.Text));
                    }
                    else if (type == "medical")
                    {
                        procName = "Submit_medical";
                        cmd.Parameters.Add(new SqlParameter("@employee_ID", Session["employee_ID"]));
                        cmd.Parameters.Add(new SqlParameter("@start_date", txtStartDate.Text));
                        cmd.Parameters.Add(new SqlParameter("@end_date", txtEndDate.Text));
                        cmd.Parameters.Add(new SqlParameter("@medical_type", "sick"));
                        cmd.Parameters.Add(new SqlParameter("@insurance_status", 1));
                        cmd.Parameters.Add(new SqlParameter("@disability_details", "None"));
                        cmd.Parameters.Add(new SqlParameter("@document_description", "Sick note"));
                        cmd.Parameters.Add(new SqlParameter("@file_name", "doc.pdf"));
                    }
                    else if (type == "compensation")
                    {
                        procName = "Submit_compensation";
                        cmd.Parameters.Add(new SqlParameter("@employee_ID", Session["employee_ID"]));
                        cmd.Parameters.Add(new SqlParameter("@compensation_date", txtStartDate.Text));
                        cmd.Parameters.Add(new SqlParameter("@reason", txtReason.Text));
                        cmd.Parameters.Add(new SqlParameter("@date_of_original_workday", txtOriginalDate.Text));
                        cmd.Parameters.Add(new SqlParameter("@rep_emp_id", txtReplacement.Text));
                    }
                    else if (type == "unpaid")
                    {
                        procName = "Submit_unpaid";
                        cmd.Parameters.Add(new SqlParameter("@employee_ID", Session["employee_ID"]));
                        cmd.Parameters.Add(new SqlParameter("@start_date", txtStartDate.Text));
                        cmd.Parameters.Add(new SqlParameter("@end_date", txtEndDate.Text));
                        cmd.Parameters.Add(new SqlParameter("@document_description", "Personal"));
                        cmd.Parameters.Add(new SqlParameter("@file_name", "none.pdf"));
                    }

                    cmd.CommandText = procName;
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();

                    lblMessage.Text = "Success! " + type + " leave applied.";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }
    }
}