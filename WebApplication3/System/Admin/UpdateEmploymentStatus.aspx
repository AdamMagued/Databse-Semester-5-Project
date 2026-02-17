<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SimpleUpdateEmploymentStatus.aspx.cs" Inherits="WebApplication4.Admin.SimpleUpdateEmploymentStatus" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Update Employment Status</title>
    <style>
        body { font-family: Arial; padding: 20px; background: #f5f5f5; }
        .container { background: white; padding: 20px; border-radius: 5px; max-width: 600px; margin: 0 auto; }
        h1 { color: #007bff; margin-top: 0; }
        .section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .input-group { margin: 15px 0; }
        label { display: inline-block; width: 150px; font-weight: bold; }
        input[type="text"] { padding: 8px; width: 200px; border: 1px solid #ddd; border-radius: 4px; }
        .button { padding: 10px 20px; background: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; margin-right: 10px; }
        .button-success { background: #28a745; }
        .button-success:hover { background: #218838; }
        .button-warning { background: #ffc107; color: #212529; }
        .button-warning:hover { background: #e0a800; }
        .message { padding: 10px; margin: 10px 0; border-radius: 4px; }
        .success { background: #d4edda; color: #155724; }
        .error { background: #f8d7da; color: #721c24; }
        .warning { background: #fff3cd; color: #856404; }
        .info { background: #d1ecf1; color: #0c5460; }
        .status-badge { display: inline-block; padding: 3px 8px; border-radius: 12px; font-size: 12px; font-weight: bold; }
        .status-active { background: #28a745; color: white; }
        .status-onleave { background: #ffc107; color: #212529; }
        .status-notice { background: #fd7e14; color: white; }
        .status-resigned { background: #dc3545; color: white; }
        .employee-info { background: #f8f9fa; padding: 15px; border-radius: 5px; margin: 15px 0; }
        .today { font-weight: bold; color: #007bff; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h1>👨‍💼 Update Employment Status</h1>
            <p>Update employee status based on leave status for: <span class="today"><%= DateTime.Now.ToString("dddd, MMMM dd, yyyy") %></span></p>
            
            <!-- Message Display -->
            <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>
            
            <!-- Single Employee Update -->
            <div class="section">
                <h3>1. Update Single Employee</h3>
                
                <div class="input-group">
                    <label for="txtEmployeeID">Employee ID:</label>
                    <asp:TextBox ID="txtEmployeeID" runat="server" placeholder="Enter Employee ID"></asp:TextBox>
                </div>
                
                <div style="margin-top: 20px;">
                    <asp:Button ID="btnCheckStatus" runat="server" Text="🔍 Check Current Status" 
                        OnClick="btnCheckStatus_Click" CssClass="button" />
                    <asp:Button ID="btnUpdateSingle" runat="server" Text="🔄 Update This Employee" 
                        OnClick="btnUpdateSingle_Click" CssClass="button button-success" />
                </div>
                
                <!-- Employee Info Display -->
                <asp:Panel ID="pnlEmployeeInfo" runat="server" Visible="false" CssClass="employee-info">
                    <h4>Employee Information</h4>
                    <p><strong>Employee ID:</strong> <asp:Label ID="lblEmpID" runat="server" Text=""></asp:Label></p>
                    <p><strong>Name:</strong> <asp:Label ID="lblEmpName" runat="server" Text=""></asp:Label></p>
                    <p><strong>Current Status:</strong> 
                        <asp:Label ID="lblCurrentStatusBadge" runat="server" CssClass="status-badge" Text=""></asp:Label>
                    </p>
                    <p><strong>On Leave Today:</strong> <asp:Label ID="lblOnLeave" runat="server" Text=""></asp:Label></p>
                    <p><strong>New Status:</strong> 
                        <asp:Label ID="lblNewStatusBadge" runat="server" CssClass="status-badge" Text=""></asp:Label>
                    </p>
                </asp:Panel>
            </div>
            
            <!-- Bulk Update -->
            <div class="section">
                <h3>2. Update All Employees</h3>
                <p>Update employment status for ALL employees based on today's leave status.</p>
                
                <div style="margin-top: 15px;">
                    <asp:Button ID="btnUpdateAll" runat="server" Text="🔄 UPDATE ALL EMPLOYEES" 
                        OnClick="btnUpdateAll_Click" CssClass="button button-warning" 
                        OnClientClick="return confirm('This will update ALL employees. Are you sure?');" />
                </div>
            </div>
            
            <!-- Recently Updated -->
            <div class="section">
                <h3>3. Recently Updated Employees</h3>
                <asp:Button ID="btnRefreshList" runat="server" Text="🔄 Refresh List" 
                    OnClick="btnRefreshList_Click" CssClass="button" />
                
                <asp:GridView ID="gvUpdatedEmployees" runat="server" AutoGenerateColumns="false" 
                    EmptyDataText="No employees updated yet." style="margin-top: 15px;"
                    OnRowDataBound="gvUpdatedEmployees_RowDataBound">
                    <Columns>
                        <asp:BoundField DataField="employee_id" HeaderText="ID" ItemStyle-Width="80px" />
                        <asp:BoundField DataField="employee_name" HeaderText="Name" />
                        <asp:TemplateField HeaderText="Old Status" ItemStyle-Width="100px">
                            <ItemTemplate>
                                <asp:Label ID="lblOldStatus" runat="server" CssClass="status-badge" Text='<%# Eval("old_status") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="New Status" ItemStyle-Width="100px">
                            <ItemTemplate>
                                <asp:Label ID="lblNewStatus" runat="server" CssClass="status-badge" Text='<%# Eval("new_status") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="updated_time" HeaderText="Updated" DataFormatString="{0:HH:mm}" ItemStyle-Width="80px" />
                    </Columns>
                </asp:GridView>
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