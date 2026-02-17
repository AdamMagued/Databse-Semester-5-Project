<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="WebApplication4.Admin.AdminDashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Dashboard</title>
    <style>
        body { font-family: Arial; padding: 20px; background: #f5f5f5; }
        .header { background: #007bff; color: white; padding: 20px; border-radius: 5px; }
        .menu { background: #e9ecef; padding: 15px; margin: 20px 0; border-radius: 5px; }
        .menu a { display: inline-block; margin: 5px 10px; padding: 10px 15px; 
                 background: white; text-decoration: none; color: #333; border-radius: 3px; 
                 border: 1px solid #ddd; }
        .menu a:hover { background: #007bff; color: white; border-color: #007bff; }
        .functions { display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; }
        .function-box { background: white; padding: 15px; border-radius: 5px; border: 1px solid #ddd; }
        .function-box h3 { color: #007bff; margin-top: 0; }
        .logout { float: right; }
        
        /* New button styles */
        .button-container { margin: 20px 0; }
        .nav-button {
            display: inline-block;
            margin: 5px 10px;
            padding: 10px 20px;
            background: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }
        .nav-button:hover {
            background: #0056b3;
        }
        .nav-button-secondary {
            background: #6c757d;
        }
        .nav-button-secondary:hover {
            background: #545b62;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <h1>👨‍💼 Admin Dashboard</h1>
            <p>
                <asp:Label ID="lblWelcome" runat="server" Text="Welcome, Administrator!"></asp:Label> | 
                </p>
        </div>
        <div style="text-align: center; margin: 20px 0; padding: 15px; background: #e7f5ff; border-radius: 5px;">
    <h3 style="margin-top: 0; color: #0066cc;">Go to Admin Part 1</h3>
    <asp:Button ID="btnGoToAdminPart1" runat="server" Text="🚀 Go to Admin Page (Part 1)" 
        OnClick="btnGoToAdminPart1_Click" 
        style="padding: 10px 20px; background: #28a745; color: white; border: none; border-radius: 5px; cursor: pointer;" />
</div>
        <!-- Button Navigation -->
        <div class="button-container">
            <h3>Navigate with Buttons:</h3>
            <asp:Button ID="btnYesterday" runat="server" Text="📊 Yesterday's Attendance" OnClick="btnYesterday_Click" CssClass="nav-button" />
            <asp:Button ID="btnWinter" runat="server" Text="❄️ Winter Performance" OnClick="btnWinter_Click" CssClass="nav-button" />
            <asp:Button ID="btnRemoveHoliday" runat="server" Text="🗑️ Remove Holiday Attendance" OnClick="btnRemoveHoliday_Click" CssClass="nav-button" />
            <asp:Button ID="btnRemoveDayOff" runat="server" Text="📅 Remove Day Off" OnClick="btnRemoveDayOff_Click" CssClass="nav-button" />
            <asp:Button ID="btnRemoveLeaves" runat="server" Text="📝 Remove Approved Leaves" OnClick="btnRemoveLeaves_Click" CssClass="nav-button" />
            <asp:Button ID="btnReplace" runat="server" Text="🔄 Replace Employee" OnClick="btnReplace_Click" CssClass="nav-button" />
            <asp:Button ID="btnUpdateStatus" runat="server" Text="👨‍💼 Update Employment Status" OnClick="btnUpdateStatus_Click" CssClass="nav-button" />
        </div>
        
        <div class="menu">
            <h3>Quick Navigation (Links):</h3>
            <a href="YesterdayAttendance.aspx">📊 Yesterday's Attendance</a>
            <a href="WinterPerformance.aspx">❄️ Winter Performance</a>
            <a href="RemoveHolidayAttendance.aspx">🗑️ Remove Holiday Attendance</a>
            <a href="RemoveDayOff.aspx">📅 Remove Day Off</a>
            <a href="RemoveApprovedLeaves.aspx">📝 Remove Approved Leaves</a>
            <a href="ReplaceEmployee.aspx">🔄 Replace Employee</a>
            <a href="UpdateEmploymentStatus.aspx">👨‍💼 Update Employment Status</a>
        </div>
        
        <h2>Admin Functions - Part 2</h2>
        <div class="functions">
            <div class="function-box">
                <h3>1. Yesterday's Attendance</h3>
                <p>View attendance records for all employees for yesterday.</p>
                <asp:Button ID="btnGoYesterday" runat="server" Text="Go →" OnClick="btnYesterday_Click" 
                    CssClass="nav-button" Width="80px" />
            </div>
            
            <div class="function-box">
                <h3>2. Winter Performance</h3>
                <p>View performance of all employees in Winter semesters.</p>
                <asp:Button ID="btnGoWinter" runat="server" Text="Go →" OnClick="btnWinter_Click" 
                    CssClass="nav-button" Width="80px" />
            </div>
            
            <div class="function-box">
                <h3>3. Remove Holiday Attendance</h3>
                <p>Delete attendance records during official holidays.</p>
                <asp:Button ID="btnGoRemoveHoliday" runat="server" Text="Go →" OnClick="btnRemoveHoliday_Click" 
                    CssClass="nav-button" Width="80px" />
            </div>
            
            <div class="function-box">
                <h3>4. Remove Day Off</h3>
                <p>Remove unattended day off for an employee.</p>
                <asp:Button ID="btnGoRemoveDayOff" runat="server" Text="Go →" OnClick="btnRemoveDayOff_Click" 
                    CssClass="nav-button" Width="80px" />
            </div>
            
            <div class="function-box">
                <h3>5. Remove Approved Leaves</h3>
                <p>Remove approved leaves from attendance records.</p>
                <asp:Button ID="btnGoRemoveLeaves" runat="server" Text="Go →" OnClick="btnRemoveLeaves_Click" 
                    CssClass="nav-button" Width="80px" />
            </div>
            
            <div class="function-box">
                <h3>6. Replace Employee</h3>
                <p>Assign replacement for an employee temporarily.</p>
                <asp:Button ID="btnGoReplace" runat="server" Text="Go →" OnClick="btnReplace_Click" 
                    CssClass="nav-button" Width="80px" />
            </div>
            
            <div class="function-box">
                <h3>7. Update Employment Status</h3>
                <p>Update status based on leave/active status.</p>
                <asp:Button ID="btnGoUpdateStatus" runat="server" Text="Go →" OnClick="btnUpdateStatus_Click" 
                    CssClass="nav-button" Width="80px" />
            </div>
        </div>
        
        <div style="margin-top: 30px; padding: 15px; background: #fff3cd; border-radius: 5px;">
            <h3>📋 Demo Mode Active</h3>
            <p>All functions show sample data. To connect to real database:</p>
            <ol>
                <li>Uncomment database code in .cs files</li>
                <li>Update connection string in Web.config</li>
                <li>Call your stored procedures from Milestone 2</li>
            </ol>
        </div>
        
        <!-- Status Message -->
        <div style="margin-top: 20px;">
            <asp:Label ID="lblStatus" runat="server" Text="" ForeColor="Green"></asp:Label>
        </div>
    </form>
</body>
</html>