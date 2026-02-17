<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SimpleRemoveApprovedLeaves.aspx.cs" Inherits="WebApplication4.Admin.SimpleRemoveApprovedLeaves" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Remove Approved Leaves</title>
    <style>
        body { font-family: Arial; padding: 20px; background: #f5f5f5; }
        .container { background: white; padding: 20px; border-radius: 5px; max-width: 900px; margin: 0 auto; }
        h1 { color: #007bff; margin-top: 0; }
        .section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        table { width: 100%; border-collapse: collapse; margin: 15px 0; }
        th { background: #007bff; color: white; padding: 10px; text-align: left; }
        td { padding: 8px; border-bottom: 1px solid #ddd; }
        .button { padding: 10px 20px; background: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; }
        .button-danger { background: #dc3545; }
        .button-danger:hover { background: #c82333; }
        .message { padding: 10px; margin: 10px 0; border-radius: 4px; }
        .success { background: #d4edda; color: #155724; }
        .error { background: #f8d7da; color: #721c24; }
        .warning { background: #fff3cd; color: #856404; }
        .info { background: #d1ecf1; color: #0c5460; }
        .no-data { text-align: center; padding: 20px; color: #6c757d; }
        .leave-type { display: inline-block; padding: 3px 8px; border-radius: 3px; font-size: 12px; }
        .annual { background: #28a745; color: white; }
        .accidental { background: #17a2b8; color: white; }
        .medical { background: #6f42c1; color: white; }
        .unpaid { background: #fd7e14; color: white; }
        .compensation { background: #20c997; color: white; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h1>Remove Approved Leaves from Attendance</h1>
            
            <!-- Employee Selection -->
            <div class="section">
                <h3>1. Select Employee</h3>
                <div style="margin-bottom: 15px;">
                    <asp:Label ID="lblEmployeeID" runat="server" Text="Employee ID: "></asp:Label>
                    <asp:TextBox ID="txtEmployeeID" runat="server" Width="100px"></asp:TextBox>
                    <asp:Button ID="btnLoad" runat="server" Text="Load Data" OnClick="btnLoad_Click" CssClass="button" />
                </div>
                
                <!-- Employee Info -->
                <asp:Panel ID="pnlEmployeeInfo" runat="server" Visible="false">
                    <p><strong>Name:</strong> <asp:Label ID="lblEmployeeName" runat="server" Text=""></asp:Label></p>
                    <p><strong>Department:</strong> <asp:Label ID="lblDepartment" runat="server" Text=""></asp:Label></p>
                    <p><strong>Approved Leaves:</strong> <asp:Label ID="lblLeaveCount" runat="server" Text="0"></asp:Label> found</p>
                </asp:Panel>
            </div>
            
            <!-- Message Display -->
            <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>
            
            <!-- Section 1: Approved Leaves -->
            <div class="section">
                <h3>2. Employee's Approved Leaves</h3>
                <asp:GridView ID="gvLeaves" runat="server" AutoGenerateColumns="false" 
                    EmptyDataText="No approved leaves found for this employee.">
                    <Columns>
                        <asp:BoundField DataField="leave_type" HeaderText="Type" />
                        <asp:BoundField DataField="start_date" HeaderText="Start Date" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:BoundField DataField="end_date" HeaderText="End Date" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:BoundField DataField="num_days" HeaderText="Days" />
                        <asp:BoundField DataField="date_of_request" HeaderText="Requested On" DataFormatString="{0:yyyy-MM-dd}" />
                    </Columns>
                </asp:GridView>
            </div>
            
            <!-- Section 2: Attendance During Leaves -->
            <div class="section">
                <h3>3. Attendance During Approved Leaves</h3>
                <asp:Label ID="lblAttendanceCount" runat="server" Text=""></asp:Label>
                
                <asp:GridView ID="gvAttendance" runat="server" AutoGenerateColumns="false" 
                    EmptyDataText="No attendance records found during approved leaves.">
                    <Columns>
                        <asp:BoundField DataField="date" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd (dddd)}" />
                        <asp:BoundField DataField="check_in_time" HeaderText="Check In" DataFormatString="{0:hh\:mm}" />
                        <asp:BoundField DataField="check_out_time" HeaderText="Check Out" DataFormatString="{0:hh\:mm}" />
                        <asp:BoundField DataField="status" HeaderText="Status" />
                        <asp:BoundField DataField="leave_type" HeaderText="During Leave" />
                    </Columns>
                </asp:GridView>
            </div>
            
            <!-- Action Section -->
            <div class="section" style="background: #f8d7da; border-color: #dc3545;">
                <h3 style="color: #dc3545;">4. Remove These Records</h3>
                <p><strong>Action:</strong> Delete attendance records where employee was absent during approved leaves.</p>
                <p>This will permanently delete the attendance records shown above.</p>
                
                <div style="margin-top: 15px;">
                    <asp:Button ID="btnRemove" runat="server" Text="🗑️ Remove Approved Leave Attendance" 
                        OnClick="btnRemove_Click" CssClass="button button-danger" 
                        Enabled="false" OnClientClick="return confirm('Are you sure you want to delete these attendance records?');" />
                </div>
            </div>
            
            <!-- Back Button -->
            <div style="margin-top: 20px;">
                <asp:Button ID="btnBack" runat="server" Text="← Back to Dashboard" 
                    OnClick="btnBack_Click" CssClass="button" />
            </div>
        </div>
    </form>
</body>
</html>
