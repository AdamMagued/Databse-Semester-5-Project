<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SimpleRemoveDayOff.aspx.cs" Inherits="WebApplication4.Admin.SimpleRemoveDayOff" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Remove Day Off Records</title>
    <style>
        body { font-family: Arial; padding: 20px; background: #f5f5f5; }
        .container { background: white; padding: 20px; border-radius: 5px; max-width: 800px; margin: 0 auto; }
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
        .no-data { text-align: center; padding: 20px; color: #6c757d; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h1>Remove Day Off Records</h1>
            
            <!-- Employee Selection -->
            <div class="section">
                <h3>1. Select Employee</h3>
                <div style="margin-bottom: 15px;">
                    <asp:Label ID="lblEmployeeID" runat="server" Text="Employee ID: "></asp:Label>
                    <asp:TextBox ID="txtEmployeeID" runat="server" Width="100px"></asp:TextBox>
                    <asp:Button ID="btnLoad" runat="server" Text="Load Records" OnClick="btnLoad_Click" CssClass="button" />
                </div>
                
                <!-- Employee Info -->
                <asp:Panel ID="pnlEmployeeInfo" runat="server" Visible="false">
                    <p><strong>Name:</strong> <asp:Label ID="lblEmployeeName" runat="server" Text=""></asp:Label></p>
                    <p><strong>Department:</strong> <asp:Label ID="lblDepartment" runat="server" Text=""></asp:Label></p>
                    <p><strong>Official Day Off:</strong> <asp:Label ID="lblDayOff" runat="server" Text=""></asp:Label></p>
                </asp:Panel>
            </div>
            
            <!-- Message Display -->
            <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>
            
            <!-- Records to Delete -->
            <div class="section">
                <h3>2. Records to Remove</h3>
                <asp:Label ID="lblCount" runat="server" Text=""></asp:Label>
                
                <asp:GridView ID="gvRecords" runat="server" AutoGenerateColumns="false" 
                    EmptyDataText="No unattended day off records found for this employee in current month.">
                    <Columns>
                        <asp:BoundField DataField="date" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd (dddd)}" />
                        <asp:BoundField DataField="status" HeaderText="Status" />
                        <asp:BoundField DataField="check_in_time" HeaderText="Check In" DataFormatString="{0:hh\:mm}" />
                        <asp:BoundField DataField="check_out_time" HeaderText="Check Out" DataFormatString="{0:hh\:mm}" />
                    </Columns>
                </asp:GridView>
            </div>
            
            <!-- Action Button -->
            <div class="section">
                <h3>3. Remove Records</h3>
                <asp:Button ID="btnRemove" runat="server" Text="Remove These Records" 
                    OnClick="btnRemove_Click" CssClass="button button-danger" 
                    Enabled="false" />
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