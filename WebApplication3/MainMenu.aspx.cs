using System;
using System.Web.UI;

namespace WebApplication1
{
    public partial class MainMenu : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Ensure user is logged in
            if (Session["employee_ID"] == null)
            {
                Response.Redirect("Login.aspx");
            }
        }

        protected void btnPerformance_Click(object sender, EventArgs e)
        {
            Response.Redirect("Performance.aspx");
        }

        protected void btnAttendance_Click(object sender, EventArgs e)
        {
            Response.Redirect("Attendance.aspx");
        }

        protected void btnPayroll_Click(object sender, EventArgs e)
        {
            Response.Redirect("LastMonthPayroll.aspx");
        }

        protected void btnDeductions_Click(object sender, EventArgs e)
        {
            Response.Redirect("DeductionsAttendance.aspx");
        }

        protected void btnApplyAnnualLeave_Click(object sender, EventArgs e)
        {
            Response.Redirect("ApplyAnnualLeave.aspx");
        }

        protected void btnLeaveStatus_Click(object sender, EventArgs e)
        {
            Response.Redirect("StatusLeaves.aspx");
        }

        // NEW BUTTON HANDLERS
        protected void btnApplyLeave_Click(object sender, EventArgs e)
        {
            Response.Redirect("ApplyLeave.aspx");
        }

        protected void btnViewLeaves_Click(object sender, EventArgs e)
        {
            Response.Redirect("ViewLeaves.aspx");
        }

        protected void btnEvaluate_Click(object sender, EventArgs e)
        {
            Response.Redirect("Evaluate.aspx");
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }
    }
}
