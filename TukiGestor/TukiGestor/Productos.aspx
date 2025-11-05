<%@ Page Title="Stock" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Productos.aspx.cs" Inherits="TukiGestor.Stock" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .productos-container {
            position: fixed;
            left: calc(50vw + 140px);
            transform: translateX(-50%);
            top: 40px;
            z-index: 100;
            min-width: 80%;
            max-width: 1400px;
            padding: 20px;
            padding-bottom: 120px;
            min-height: 80vh;
        }

        .tabs-container {
            background: #F6EFE0;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            min-height: 80vh;
        }

        .nav-tabs {
            border-bottom: 2px solid #E7D9C2;
            margin-bottom: 10px;
        }

        .nav-tabs .nav-link {
            color: #333;
            border: none;
            padding: 12px 30px;
            font-weight: 600;
            border-radius: 8px 8px 0 0;
            transition: all 0.3s ease;
        }

        .nav-tabs .nav-link.active {
            background-color: #E7D9C2;
            color: #333;
            border: none;
        }

        .btn-custom {
            background-color: #E7D9C2 !important;
            border: none;
            color: #000 !important;
        }

        .btn-custom:hover {
            background-color: #d8cfc7 !important;
        }

        .table {
            background-color: #fff;
            border-radius: 10px;
            overflow: hidden;
        }

        .tab-pane {
            display: none;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .tab-pane.active.show {
            display: block;
            opacity: 1;
        }




        .tabla-scroll {
            max-height: 500px;
            overflow-y: auto;
            overflow-x: hidden;
            border-radius: 10px;
            box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.1);
        }

        .tabla-scroll::-webkit-scrollbar {
            width: 8px;
        }

        .tabla-scroll::-webkit-scrollbar-thumb {
            background-color: #cfcfcf;
            border-radius: 10px;
        }

        .tabla-scroll::-webkit-scrollbar-thumb:hover {
            background-color: #b0b0b0;
        }


    </style>

    <div class="productos-container">
        <div class="tabs-container">
            <h2 class="mb-4" style="color: #333; font-weight: bold;">
                <i class="bi bi-box-seam"></i> Gestión de Productos
            </h2>

            <!-- Solapas -->
            <ul class="nav nav-tabs" role="tablist">
                <li class="nav-item">
                    <button class="nav-link active" id="stock-tab" data-bs-toggle="tab" data-bs-target="#stock" type="button" role="tab">
                        <i class="bi bi-list-ul"></i> Listado
                    </button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" id="nuevo-tab" data-bs-toggle="tab" data-bs-target="#nuevo" type="button" role="tab">
                        <i class="bi bi-plus-circle"></i> Nuevo producto
                    </button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" id="categorias-tab" data-bs-toggle="tab" data-bs-target="#categorias" type="button" role="tab">
                        <i class="bi bi-list-ul"></i> Categorias
                    </button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" id="categoriaNueva-tab" data-bs-toggle="tab" data-bs-target="#categoriaNueva" type="button" role="tab">
                        <i class="bi bi-plus-circle"></i> Categoría nueva</button>
                </li>
            </ul>

            <!-- contenido de las solapas -->
            <div class="tab-content mt-3">

                <!-- LISTADO -->
                <div class="tab-pane fade active show" id="stock" role="tabpanel">
                    <div class="d-flex justify-content-center mb-4">
                        <div class="input-group" style="width: 400px;">
                            <span class="input-group-text"><i class="bi bi-search"></i></span>
                            <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control" placeholder="Buscar producto..."></asp:TextBox>
                        </div>
                    </div>
                    <asp:Repeater ID="RepeaterProductos" runat="server" OnItemCommand="RepeaterProductos_ItemCommand">
                        <HeaderTemplate>
                            <div class="tabla-scroll">
                                <table class="table table-striped table-hover text-center shadow-lg">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>Nombre</th>
                                            <th>Cantidad</th>
                                            <th>Precio</th>
                                            <th>Eliminar</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td><%# Eval("Nombre") %></td>
                                <td><%# Eval("Stock") %></td>
                                <td>$<%# Eval("Precio") %></td>
                                <td>
                                    <asp:LinkButton runat="server" CssClass="btn btn-link text-danger" CommandName="Eliminar" CommandArgument='<%# Eval("ProductoId") %>'>
                                        <i class="bi bi-trash-fill"></i>
                                    </asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            </tbody>
                            </table>
                            </div>
                        </FooterTemplate>
                    </asp:Repeater>

                </div>

                <!-- NUEVO PRODUCTO -->
                <div class="tab-pane fade" id="nuevo" role="tabpanel">
                    <div class="p-4">
                        <h4 class="mb-3">Agregar nuevo producto</h4>
                        <div class="mb-3">
                            <label for="ddlCategorias" class="form-label">Categoría</label>
                            <asp:DropDownList ID="ddlCategorias" runat="server" CssClass="form-control"></asp:DropDownList>
                        </div>
                        <div class="mb-3">
                            <label for="txtNombre" class="form-label">Nombre</label>
                            <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" placeholder="Ej: Pizza Napolitana"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label for="txtCantidad" class="form-label">Cantidad</label>
                            <asp:TextBox ID="txtCantidad" runat="server" CssClass="form-control" TextMode="Number" placeholder="Ej: 50"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label for="txtPrecio" class="form-label">Precio</label>
                            <asp:TextBox ID="txtPrecio" runat="server" CssClass="form-control" TextMode="Number" placeholder="Ej: 1200"></asp:TextBox>
                        </div>
                        <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn btn-custom mt-3" OnClick="btnGuardar_Click" />
                    </div>
                </div>

                <!-- CATEGORIAS -->
                <div class="tab-pane fade" id="categorias" role="tabpanel">
                    <div class="p-4">
                        <h4 class="mb-3 text-center">Categorías de productos</h4>
                        <div style="max-height: 400px; overflow-y: auto; border-radius: 8px;">
                            <asp:Repeater ID="RepeaterCategorias" runat="server" OnItemCommand="RepeaterCategorias_ItemCommand">
                                <HeaderTemplate>
                                    <table class="table table-striped table-hover text-center shadow-lg mb-0">
                                        <thead class="table-dark sticky-top">
                                            <tr>
                                                <th>Nombre</th>
                                                <th>Eliminar</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Eval("Nombre") %></td>
                                        <td>
                                            <asp:LinkButton runat="server" CssClass="btn btn-link text-danger" CommandName="Eliminar" CommandArgument='<%# Eval("CategoriaId") %>'>
                                                <i class="bi bi-trash-fill"></i>
                                            </asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                        </tbody>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>

                <!-- NUEVA CATEGORÍA -->
                <div class="tab-pane fade" id="categoriaNueva" role="tabpanel">
                    <div class="p-4">
                        <h4 class="mb-3">Agregar nueva categoría</h4>
                        <div class="mb-3">
                            <label for="txtNombreCategoria" class="form-label">Nombre</label>
                            <asp:TextBox ID="txtNombreCategoria" runat="server" CssClass="form-control" placeholder="Ej: Entrada"></asp:TextBox>
                        </div>
                        <asp:Button ID="btnGuardarCategoria" runat="server" Text="Guardar" CssClass="btn btn-custom mt-3" OnClick="btnGuardarCategoria_Click" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
