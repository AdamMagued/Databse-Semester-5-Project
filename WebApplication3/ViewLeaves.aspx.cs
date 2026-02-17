using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Data;

namespace WebApplication1
{
    public partial class ViewLeaves : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["employee_ID"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            else if (!IsPostBack)
            {
                BindGrid();
            }
        }

        protected void BindGrid()
        {
            string connStr = WebConfigurationManager.ConnectionStrings["MyDatabaseConnection"].ToString();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT L.request_ID AS leave_id, 
                           CASE 
                               WHEN UL.request_ID IS NOT NULL THEN 'Unpaid'
                               WHEN AL.request_ID IS NOT NULL THEN 'Annual'
                               ELSE 'Other'
                           END AS type, 
                           L.start_date, 
                           L.end_date
                    FROM Leave L
                    INNER JOIN Employee_Approve_Leave EAL ON L.request_ID = EAL.leave_ID
                    LEFT JOIN Unpaid_Leave UL ON L.request_ID = UL.request_ID
                    LEFT JOIN Annual_Leave AL ON L.request_ID = AL.request_ID
                    WHERE EAL.Emp1_ID = @manager_id AND EAL.status = 'Pending'";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.CommandType = CommandType.Text;
                cmd.Parameters.Add(new SqlParameter("@manager_id", Session["employee_ID"]));

                conn.Open();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gridLeaves.DataSource = dt;
                gridLeaves.DataBind();
            }
        }

        protected void gridLeaves_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int rowIndex = Convert.ToInt32(e.CommandArgument);
            int leaveId = Convert.ToInt32(gridLeaves.DataKeys[rowIndex].Values["leave_id"]);
            string type = gridLeaves.DataKeys[rowIndex].Values["type"].ToString();

            string connStr = WebConfigurationManager.ConnectionStrings["University_HR_ManagementSystem"].ToString();
            string commandName = e.CommandName;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandType = CommandType.StoredProcedure;

                // ---------------------------------------------------------
                //  STRICT ACADEMIC PART 2 LOGIC (No HR, No Accidental)
                // ---------------------------------------------------------

                if (commandName == "Reject")
                {
                    // Assuming we want to simply mark it rejected on our end
                    cmd.CommandText = "UPDATE Employee_Approve_Leave SET status='Rejected' WHERE leave_ID=@rid AND Emp1_ID=@eid";
                    cmd.CommandType = CommandType.Text;
                    cmd.Parameters.Add(new SqlParameter("@rid", leaveId));
                    cmd.Parameters.Add(new SqlParameter("@eid", Session["employee_ID"]));
                }
                else // Approve
                {
                    if (type == "Unpaid")
                    {
                        // Use Upperboard Proc
                        cmd.CommandText = "Upperboard_approve_unpaids";
                        cmd.Parameters.Add(new SqlParameter("@request_ID", leaveId));
                        cmd.Parameters.Add(new SqlParameter("@upperboard_ID", Session["employee_ID"]));
                    }
                    else if (type == "Annual")
                    {
                        // Use Upperboard Proc
                        cmd.CommandText = "Upperboard_approve_annual";
                        cmd.Parameters.Add(new SqlParameter("@request_ID", leaveId));
                        cmd.Parameters.Add(new SqlParameter("@Upperboard_ID", Session["employee_ID"]));

                        // We must fetch the replacement ID manually to satisfy the SQL proc
                        int replacementId = 0;
                        using (SqlConnection conn2 = new SqlConnection(connStr))
                        {
                            string sql = "SELECT replacement_emp FROM Annual_Leave WHERE request_ID = @rid";
                            SqlCommand cmdFetch = new SqlCommand(sql, conn2);
                            cmdFetch.Parameters.Add(new SqlParameter("@rid", leaveId));
                            conn2.Open();
                            object result = cmdFetch.ExecuteScalar();
                            if (result != null && result != DBNull.Value) replacementId = Convert.ToInt32(result);
                            conn2.Close();
                        }
                        cmd.Parameters.Add(new SqlParameter("@replacement_ID", replacementId));
                    }
                    else
                    {
                        // Part 2 Academic Employee DOES NOT approve Accidental/Medical/Compensation
                        lblMsg.Text = "You are not authorized to approve " + type + " leaves.";
                        lblMsg.ForeColor = System.Drawing.Color.Red;
                        return;
                    }
                }

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();

                    // ---------------------------------------------------------
                    //  CHECK THE RESULT (Feedback Logic)
                    // ---------------------------------------------------------
                    // We check Employee_Approve_Leave to see if *our* action was recorded as Approved or Rejected
                    // The SQL Procedure might have auto-rejected it (e.g. balance check) even if we clicked Approve.

                    SqlCommand checkCmd = new SqlCommand("SELECT status FROM Employee_Approve_Leave WHERE leave_ID=@lid AND Emp1_ID=@eid", conn);
                    checkCmd.Parameters.Add(new SqlParameter("@lid", leaveId));
                    checkCmd.Parameters.Add(new SqlParameter("@eid", Session["employee_ID"]));

                    object statusObj = checkCmd.ExecuteScalar();
                    string status = statusObj != null ? statusObj.ToString() : "";

                    conn.Close();

                    if (status == "Rejected")
                    {
                        lblMsg.Text = "Action Processed: The request was REJECTED by the system rules (e.g. insufficient balance or rules violation).";
                        lblMsg.ForeColor = System.Drawing.Color.Red;
                    }
                    else if (status == "Approved")
                    {
                        lblMsg.Text = "Success: You have APPROVED this request.";
                        lblMsg.ForeColor = System.Drawing.Color.Green;
                    }
                    else
                    {
                        lblMsg.Text = "Action Processed.";
                        lblMsg.ForeColor = System.Drawing.Color.Green;
                    }

                    BindGrid();
                }
                catch (Exception ex)
                {
                    lblMsg.Text = "Error: " + ex.Message;
                    lblMsg.ForeColor = System.Drawing.Color.Red;
                }
            }
        }
    }
}