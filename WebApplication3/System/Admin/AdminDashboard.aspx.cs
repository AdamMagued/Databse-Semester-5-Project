using System;
using System.Web.UI;

namespace WebApplication4.Admin
{
    public partial class AdminDashboard : Page  // Changed from System.Web.UI.Page to just Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }
        protected void btnYesterday_Click(object sender, EventArgs e)
        {
            Response.Redirect("YesterdayAttendance.aspx");
        }

        protected void btnWinter_Click(object sender, EventArgs e)
        {
            Response.Redirect("WinterPerformance.aspx");
        }

        protected void btnRemoveHoliday_Click(object sender, EventArgs e)
        {
            Response.Redirect("RemoveHolidayAttendance.aspx");
        }

        protected void btnRemoveDayOff_Click(object sender, EventArgs e)
        {
            Response.Redirect("RemoveDayOff.aspx");
        }

        protected void btnRemoveLeaves_Click(object sender, EventArgs e)
        {
            Response.Redirect("RemoveApprovedLeaves.aspx");
        }

        protected void btnReplace_Click(object sender, EventArgs e)
        {
            Response.Redirect("ReplaceEmployee.aspx");
        }

        protected void btnUpdateStatus_Click(object sender, EventArgs e)
        {
            Response.Redirect("UpdateEmploymentStatus.aspx");
        }

        protected void btnGoYesterday_Click(object sender, EventArgs e)
        {
            Response.Redirect("YesterdayAttendance.aspx");
        }

        protected void btnGoWinter_Click(object sender, EventArgs e)
        {
            Response.Redirect("WinterPerformance.aspx");
        }

        // Add this method to your AdminDashboard.aspx.cs file
        protected void btnGoToAdminPart1_Click(object sender, EventArgs e)
        {
            Response.Redirect("adminpage.aspx");
        }
        protected void btnGoRemoveHoliday_Click(object sender, EventArgs e)
        {
            Response.Redirect("RemoveHolidayAttendance.aspx");
        }

        protected void btnGoRemoveDayOff_Click(object sender, EventArgs e)
        {
            Response.Redirect("RemoveDayOff.aspx");
        }

        protected void btnGoRemoveLeaves_Click(object sender, EventArgs e)
        {
            Response.Redirect("RemoveApprovedLeaves.aspx");
        }

        protected void btnGoReplace_Click(object sender, EventArgs e)
        {
            Response.Redirect("ReplaceEmployee.aspx");
        }

        protected void btnGoUpdateStatus_Click(object sender, EventArgs e)
        {
            Response.Redirect("UpdateEmploymentStatus.aspx");
        }
    }
}
