<%@ Page Title="Stock" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Stock.aspx.cs" Inherits="TukiGestor.Stock" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .container.body-content {
            padding: 0 !important;
            margin: 0 !important;
            margin-bottom: 0 !important;
            max-width: 100% !important;
            width: 100% !important;
            flex: 1 !important;
            overflow: visible !important;
        }

        .stock-container {
            position: fixed;
            left: calc(50vw + 140px);
            top: 40px;
            transform: translateX(-50%);
            z-index: 100;
            width: 90%;
            max-width: 1200px;
            padding: 20px;
            padding-bottom: 120px;
        }

        .sidebar.collapsed ~ .main-wrapper .stock-container {
            left: calc(50vw + 40px);
        }
    </style>

    <div class="stock-container">
        <h2 class="text-center mb-4">Gestión de Stock</h2>

        <table class="table table-striped table-hover text-center shadow-lg">
            <thead class="table-dark">
                <tr>
                    <th>Nombre</th>
                    <th>Descripción</th>
                    <th>Cantidad</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Papas Fritas</td>
                    <td>Porción de papas medianas</td>
                    <td>25</td>
                </tr>
                <tr>
                    <td>Cerveza Artesanal</td>
                    <td>Botella 500ml</td>
                    <td>48</td>
                </tr>
                <tr>
                    <td>Hamburguesa Clásica</td>
                    <td>Carne, lechuga, tomate y pan</td>
                    <td>12</td>
                </tr>
            </tbody>
        </table>

        <div class="d-flex justify-content-center gap-3 mt-4">
            <asp:Button ID="Button1" runat="server" Text="Nuevo producto" CssClass="btn btn-success btn-lg px-4 shadow-sm" />
            <asp:Button ID="Button2" runat="server" Text="Modificar stock" CssClass="btn btn-warning btn-lg px-4 shadow-sm" />
            <asp:Button ID="Button3" runat="server" Text="Quitar producto" CssClass="btn btn-danger btn-lg px-4 shadow-sm" />
        </div>


    </div>
</asp:Content>
