<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewLeaves.aspx.cs" Inherits="WebApplication1.ViewLeaves" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Pending Approvals</title>
    <style>
        body {
            background-color: #050505;
            background: radial-gradient(circle at top center, #1a1a1a 0%, #000000 70%);
            min-height: 100vh;
            color: #e0e0e0;
            font-family: 'Segoe UI', sans-serif;
            margin:0; padding:0;
        }

        .dash-wrapper {
            max-width: 1100px;
            margin: 60px auto;
            padding: 0 20px;
        }

        .dash-header {
            margin-bottom: 30px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            padding-bottom: 15px;
        }

        .dash-header h2 {
            font-weight: 300;
            font-size: 2rem;
            color: #ffffff;
            margin: 0;
            letter-spacing: 1px;
        }

        .glass-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 10px;
        }

        .glass-table th {
            text-align: left;
            padding: 0 20px 15px 20px;
            font-size: 0.75rem;
            text-transform: uppercase;
            color: #888;
            letter-spacing: 1px;
            border: none;
        }

        .data-row {
            background: rgba(255, 255, 255, 0.03);
            transition: transform 0.2s ease, background 0.2s ease;
        }

        .data-row:hover {
            background: rgba(255, 255, 255, 0.06);
            transform: scale(1.01);
        }

        .glass-table td {
            padding: 20px;
            border-top: 1px solid rgba(255,255,255,0.05);
            border-bottom: 1px solid rgba(255,255,255,0.05);
            vertical-align: middle;
        }

        .glass-table td:first-child { border-left: 1px solid rgba(255,255,255,0.05); border-top-left-radius: 8px; border-bottom-left-radius: 8px; }
        .glass-table td:last-child { border-right: 1px solid rgba(255,255,255,0.05); border-top-right-radius: 8px; border-bottom-right-radius: 8px; text-align: right; }

        .id-text { font-family: monospace; color: #666; font-size: 1.1rem; }
        .type-text { font-weight: 600; color: #fff; letter-spacing: 0.5px; }
        .date-text { color: #aaa; font-size: 0.9rem; }

        .btn-action {
            background: transparent;
            border: 1px solid rgba(255,255,255,0.2);
            color: #fff;
            padding: 8px 24px;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            margin-left: 8px;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-approve:hover {
            border-color: #00e676;
            color: #00e676;
            background: rgba(0, 230, 118, 0.1);
        }

        .btn-reject:hover {
            border-color: #ff1744;
            color: #ff1744;
            background: rgba(255, 23, 68, 0.1);
        }

        .empty-state {
            text-align: center;
            padding: 80px;
            background: rgba(255,255,255,0.02);
            border-radius: 8px;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .developer-signature {
    text-align: center;
    margin-top: 40px;
    padding-top: 15px;
    border-top: 1px solid rgba(255, 255, 255, 0.05); /* Very subtle line */
    font-family: 'Consolas', 'Monaco', monospace;   /* Code-like font */
    font-size: 11px;
    color: rgba(255, 255, 255, 0.3);                /* Subtle white */
    letter-spacing: 2px;                            /* Premium spacing */
    text-transform: lowercase;                      /* Minimalist look */
    pointer-events: none;                           /* Cannot be clicked */
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div class="dash-wrapper">
        <div class="dash-header">
            <h2>Pending Approvals</h2>
            <asp:Button ID="btnBack" runat="server" Text="Back to Menu" PostBackUrl="~/MainMenu.aspx" CssClass="btn-action" style="float:right; margin-top:-30px;" />
        </div>

        <asp:GridView ID="gridLeaves" runat="server" AutoGenerateColumns="false" 
            CssClass="glass-table" 
            OnRowCommand="gridLeaves_RowCommand" 
            DataKeyNames="leave_id,type" 
            GridLines="None"
            ShowHeaderWhenEmpty="true"
            RowStyle-CssClass="data-row">
            
            <Columns>
                <asp:TemplateField HeaderText="ID">
                    <ItemTemplate>
                        <span class="id-text">#<%# Eval("leave_id") %></span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Category">
                    <ItemTemplate>
                        <span class="type-text"><%# Eval("type") %></span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Date Range">
                    <ItemTemplate>
                        <span class="date-text"><%# Eval("start_date", "{0:MMM dd}") %> — <%# Eval("end_date", "{0:MMM dd}") %></span>
                    </ItemTemplate>
                </asp:TemplateField>
                
                <asp:TemplateField HeaderText="Decision">
                    <ItemTemplate>
                        <asp:Button ID="btnApprove" runat="server" CommandName="Approve" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="Approve" CssClass="btn-action btn-approve" />
                        <asp:Button ID="btnReject" runat="server" CommandName="Reject" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="Reject" CssClass="btn-action btn-reject" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>

            <EmptyDataTemplate>
                <div class="empty-state">No pending requests found.</div>
            </EmptyDataTemplate>
        </asp:GridView>

        <br />
        <center>
            <asp:Label ID="lblMsg" runat="server" Font-Size="Medium" ForeColor="#00e676"></asp:Label>
        </center>
        <div class="developer-signature">
    part made by adam magued
</div>
    </div>
    </form>
</body>
</html>