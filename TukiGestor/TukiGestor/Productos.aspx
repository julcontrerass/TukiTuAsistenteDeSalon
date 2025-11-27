<%@ Page Title="Stock" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Productos.aspx.cs" Inherits="TukiGestor.Stock" %>
<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <%: Styles.Render("~/Content/productos") %>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">    

    <div class="productos-container">
        <div class="tabs-container">
            <h2 class="mb-4" style="color: #333; font-weight: bold;">
                <i class="bi bi-box-seam"></i> Gestión de Productos
            </h2>

            <asp:UpdatePanel ID="UpdatePanelMensajes" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="alert-custom">
                        <asp:Label ID="lblMensaje" runat="server"></asp:Label>
                    </asp:Panel>
                </ContentTemplate>
            </asp:UpdatePanel>

            <!-- Solapas -->
            <ul class="nav nav-tabs" role="tablist">
                <li class="nav-item">
                    <asp:LinkButton ID="btnTabListado" runat="server" CssClass="nav-link active" OnClick="btnTabListado_Click">
                        <i class="bi bi-list-ul"></i> Listado
                    </asp:LinkButton>
                </li>
                <li class="nav-item">
                    <asp:LinkButton ID="btnTabNuevo" runat="server" CssClass="nav-link" OnClick="btnTabNuevo_Click">
                        <i class="bi bi-plus-circle"></i> Nuevo producto
                    </asp:LinkButton>
                </li>
                <li class="nav-item">
                    <asp:LinkButton ID="btnTabCategorias" runat="server" CssClass="nav-link" OnClick="btnTabCategorias_Click">
                        <i class="bi bi-list-ul"></i> Categorías
                    </asp:LinkButton>
                </li>
                <li class="nav-item">
                    <asp:LinkButton ID="btnTabCategoriaNueva" runat="server" CssClass="nav-link" OnClick="btnTabCategoriaNueva_Click">
                        <i class="bi bi-plus-circle"></i> Categoría nueva
                    </asp:LinkButton>
                </li>
                <li class="nav-item">
                    <asp:LinkButton ID="btnTabEliminados" runat="server" CssClass="nav-link" OnClick="btnTabEliminados_Click">
                        <i class="bi bi-archive"></i> Productos Eliminados
                    </asp:LinkButton>
                </li>
                <li class="nav-item">
                    <asp:LinkButton ID="btnTabCategoriasEliminadas" runat="server" CssClass="nav-link" OnClick="btnTabCategoriasEliminadas_Click">
                        <i class="bi bi-archive"></i> Categorías Eliminadas
                    </asp:LinkButton>
                </li>
            </ul>
            <!-- contenido de las solapas -->
            <asp:UpdatePanel ID="UpdatePanelContenido" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <div class="tab-content mt-3">
                        <!-- listado -->
                        <asp:Panel ID="pnlListado" runat="server" CssClass="tab-pane fade active show">
                            <div class="d-flex justify-content-center align-items-center mb-4 gap-3">
                                <!-- Buscador -->
                                <div class="input-group" style="width: 400px;">
                                    <span class="input-group-text"><i class="bi bi-search"></i></span>
                                    <asp:TextBox ID="txtBuscarProducto" runat="server" CssClass="form-control" placeholder="Buscar producto..." AutoPostBack="true" OnTextChanged="txtBuscarProducto_TextChanged"></asp:TextBox>
                                </div>
                                <!-- Filtro por categoría -->
                                <div style="width: 250px;">
                                    <asp:DropDownList ID="ddlFiltroCategoria" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlFiltroCategoria_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </div>
                                <!-- Filtro de ordenamiento -->
                                <div style="width: 250px;">
                                    <asp:DropDownList ID="ddlOrdenamiento" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlOrdenamiento_SelectedIndexChanged">
                                        <asp:ListItem Value="reciente" Text="Más recientes primero" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="nombre_asc" Text="Nombre (A-Z)"></asp:ListItem>
                                        <asp:ListItem Value="nombre_desc" Text="Nombre (Z-A)"></asp:ListItem>
                                        <asp:ListItem Value="precio_asc" Text="Precio (Menor a Mayor)"></asp:ListItem>
                                        <asp:ListItem Value="precio_desc" Text="Precio (Mayor a Menor)"></asp:ListItem>
                                        <asp:ListItem Value="stock_asc" Text="Stock (Menor a Mayor)"></asp:ListItem>
                                        <asp:ListItem Value="stock_desc" Text="Stock (Mayor a Menor)"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <!-- Botón limpiar filtros -->
                                <asp:LinkButton ID="btnLimpiarFiltros" runat="server" CssClass="btn btn-outline-secondary" OnClick="btnLimpiarFiltros_Click" ToolTip="Limpiar filtros">
                                    <i class="bi bi-x-circle"></i>
                                </asp:LinkButton>
                            </div>
                            
                            <div class="tabla-scroll">
    <asp:GridView ID="RepeaterProductos" 
                  runat="server" 
                  AutoGenerateColumns="false" 
                  CssClass="table table-striped table-hover text-center shadow-lg"
                  HeaderStyle-CssClass="table-dark"
                 OnRowCommand="RepeaterProductos_RowCommand">
        <Columns>

            <asp:BoundField DataField="Nombre" HeaderText="Nombre" />

            <asp:BoundField DataField="Stock" HeaderText="Cantidad" />

            <asp:TemplateField HeaderText="Precio">
                <ItemTemplate>
                    $<%# Eval("Precio") %>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Acciones">
                <ItemTemplate>
                    <asp:LinkButton runat="server"
                                    CssClass="btn btn-link text-warning me-2"
                                    CommandName="Editar"
                                    CommandArgument='<%# Eval("ProductoId") %>'>
                        <i class="bi bi-pencil-fill"></i>
                    </asp:LinkButton>

                    <asp:LinkButton runat="server"
                                    CssClass="btn btn-link text-danger"
                                    CommandName="ConfirmarEliminarProducto"
                                    CommandArgument='<%# Eval("ProductoId") %>'>
                        <i class="bi bi-trash-fill"></i>
                    </asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>

        </Columns>
    </asp:GridView>
</div>


                        </asp:Panel>
                        <!-- nuevo producto -->
                        <asp:Panel ID="pnlNuevo" runat="server" CssClass="tab-pane fade">
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
                                    <asp:TextBox ID="txtPrecio" runat="server" CssClass="form-control" placeholder="Ej: 1200"></asp:TextBox>
                                </div>
                                <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn btn-custom mt-3" OnClick="btnGuardar_Click" />
                            </div>
                        </asp:Panel>
                        <!-- editar producto -->
                        <asp:Panel ID="pnlEditar" runat="server" CssClass="tab-pane fade" Visible="false">
                            <div class="p-4">
                                <h4 class="mb-3">Editar producto</h4>
                                <asp:HiddenField ID="hfProductoId" runat="server" />
                                <div class="mb-3">
                                    <label for="ddlCategoriasEditar" class="form-label">Categoría</label>
                                    <asp:DropDownList ID="ddlCategoriasEditar" runat="server" CssClass="form-control"></asp:DropDownList>
                                </div>
                                <div class="mb-3">
                                    <label for="txtNombreEditar" class="form-label">Nombre</label>
                                    <asp:TextBox ID="txtNombreEditar" runat="server" CssClass="form-control" placeholder="Ej: Pizza Napolitana"></asp:TextBox>
                                </div>
                                <div class="mb-3">
                                    <label for="txtCantidadEditar" class="form-label">Cantidad</label>
                                    <asp:TextBox ID="txtCantidadEditar" runat="server" CssClass="form-control" TextMode="Number" placeholder="Ej: 50"></asp:TextBox>
                                </div>
                                <div class="mb-3">
                                    <label for="txtPrecioEditar" class="form-label">Precio</label>
                                    <asp:TextBox ID="txtPrecioEditar" runat="server" CssClass="form-control" placeholder="Ej: 1200"></asp:TextBox>
                                </div>
                                <div class="d-flex gap-2">
                                    <asp:Button ID="btnActualizar" runat="server" Text="Actualizar" CssClass="btn btn-custom mt-3" OnClick="btnActualizar_Click" />
                                    <asp:Button ID="btnCancelarEditar" runat="server" Text="Cancelar" CssClass="btn btn-secondary mt-3" OnClick="btnCancelarEditar_Click" />
                                </div>
                            </div>
                        </asp:Panel>
                        <!-- categorias -->
                        <asp:Panel ID="pnlCategorias" runat="server" CssClass="tab-pane fade">
                            <div class="p-4">
                                <h4 class="mb-3 text-center">Categorías de productos</h4>
                                <div style="max-height: 400px; overflow-y: auto; border-radius: 8px;">


                                    <asp:GridView ID="RepeaterCategorias"
              runat="server"
              AutoGenerateColumns="false"
              CssClass="table table-striped table-hover text-center shadow-lg mb-0"
              HeaderStyle-CssClass="table-dark sticky-top"
             OnRowCommand="RepeaterCategorias_RowCommand">
    <Columns>

        <asp:BoundField DataField="Nombre" HeaderText="Nombre" />

        <asp:TemplateField HeaderText="Acciones">
            <ItemTemplate>
                <asp:LinkButton runat="server"
                                CssClass="btn btn-link text-warning me-2"
                                CommandName="EditarCategoria"
                                CommandArgument='<%# Eval("CategoriaId") %>'>
                    <i class="bi bi-pencil-fill"></i>
                </asp:LinkButton>

                <asp:LinkButton runat="server"
                                CssClass="btn btn-link text-danger"
                                CommandName="ConfirmarEliminarCategoria"
                                CommandArgument='<%# Eval("CategoriaId") %>'>
                    <i class="bi bi-trash-fill"></i>
                </asp:LinkButton>
            </ItemTemplate>
        </asp:TemplateField>

    </Columns>
</asp:GridView>


                                    
                                </div>
                            </div>
                        </asp:Panel>
                        <!-- nueva categoria -->
                        <asp:Panel ID="pnlCategoriaNueva" runat="server" CssClass="tab-pane fade">
                            <div class="p-4">
                                <h4 class="mb-3">Agregar nueva categoría</h4>
                                <div class="mb-3">
                                    <label for="txtNombreCategoria" class="form-label">Nombre</label>
                                    <asp:TextBox ID="txtNombreCategoria" runat="server" CssClass="form-control" placeholder="Ej: Entrada"></asp:TextBox>
                                </div>
                                <asp:Button ID="btnGuardarCategoria" runat="server" Text="Guardar" CssClass="btn btn-custom mt-3" OnClick="btnGuardarCategoria_Click" />
                            </div>
                        </asp:Panel>
                        <!-- editar categoria -->
                        <asp:Panel ID="pnlEditarCategoria" runat="server" CssClass="tab-pane fade" Visible="false">
                            <div class="p-4">
                                <h4 class="mb-3">Editar categoría</h4>
                                <asp:HiddenField ID="hfCategoriaId" runat="server" />
                                <div class="mb-3">
                                    <label for="txtNombreCategoriaEditar" class="form-label">Nombre</label>
                                    <asp:TextBox ID="txtNombreCategoriaEditar" runat="server" CssClass="form-control" placeholder="Ej: Entrada"></asp:TextBox>
                                </div>
                                <div class="d-flex gap-2">
                                    <asp:Button ID="btnActualizarCategoria" runat="server" Text="Actualizar" CssClass="btn btn-custom mt-3" OnClick="btnActualizarCategoria_Click" />
                                    <asp:Button ID="btnCancelarEditarCategoria" runat="server" Text="Cancelar" CssClass="btn btn-secondary mt-3" OnClick="btnCancelarEditarCategoria_Click" />
                                </div>
                            </div>
                        </asp:Panel>
                    </div>
                    <asp:Panel ID="pnlConfirmarEliminar" runat="server" CssClass="confirmar-overlay d-flex justify-content-center align-items-center" Visible="false">
                        <div class="confirmar-box text-center">
                            <h5 class="text-warning mb-3">Confirmar eliminación</h5>
                            <asp:Label ID="lblConfirmarMensaje" runat="server" Text="¿Desea eliminar este elemento?"></asp:Label>
                            <asp:HiddenField ID="hfIdEliminar" runat="server" />
                            <asp:HiddenField ID="hfTipoEliminar" runat="server" />
                            <div class="mt-4 d-flex justify-content-around">
                                <asp:Button ID="btnAceptarEliminar" runat="server" Text="Eliminar" CssClass="btn btn-danger" OnClick="btnAceptarEliminar_Click" />
                                <asp:Button ID="btnCancelarEliminar" runat="server" Text="Cancelar" CssClass="btn btn-secondary" OnClick="btnCancelarEliminar_Click" />
                            </div>
                       </div>
                   </asp:Panel>
                    <!-- Productos Eliminados -->
                    <asp:Panel ID="pnlEliminados" runat="server" CssClass="tab-pane fade">
                        <div class="p-4">
                            <h4 class="mb-3 text-center">Productos Eliminados</h4>
                            <asp:Repeater ID="RepeaterProductosEliminados" runat="server" OnItemCommand="RepeaterProductosEliminados_ItemCommand">
                                <HeaderTemplate>
                                    <div class="tabla-scroll">
                                        <table class="table table-striped table-hover text-center shadow-lg">
                                            <thead class="table-dark">
                                                <tr>
                                                    <th>Nombre</th>
                                                    <th>Cantidad</th>
                                                    <th>Precio</th>
                                                    <th>Acciones</th>
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
                                            <asp:LinkButton runat="server" CssClass="btn btn-link text-success" CommandName="Reactivar" CommandArgument='<%# Eval("ProductoId") %>' ToolTip="Reactivar producto">
                                                <i class="bi bi-arrow-clockwise"></i> Reactivar
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
                    </asp:Panel>
                    <!-- Categorías Eliminadas -->
                    <asp:Panel ID="pnlCategoriasEliminadas" runat="server" CssClass="tab-pane fade">
                        <div class="p-4">
                            <h4 class="mb-3 text-center">Categorías Eliminadas</h4>
                            <div style="max-height: 400px; overflow-y: auto; border-radius: 8px;">
                                <asp:Repeater ID="RepeaterCategoriasEliminadas" runat="server" OnItemCommand="RepeaterCategoriasEliminadas_ItemCommand">
                                    <HeaderTemplate>
                                        <table class="table table-striped table-hover text-center shadow-lg mb-0">
                                            <thead class="table-dark sticky-top">
                                                <tr>
                                                    <th>Nombre</th>
                                                    <th>Acciones</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <td><%# Eval("Nombre") %></td>
                                            <td>
                                                <asp:LinkButton runat="server" CssClass="btn btn-link text-success" CommandName="ReactivarCategoria" CommandArgument='<%# Eval("CategoriaId") %>' ToolTip="Reactivar categoría">
                                                    <i class="bi bi-arrow-clockwise"></i> Reactivar
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
                    </asp:Panel>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
</asp:Content>