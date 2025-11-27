<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Reporte.aspx.cs" Inherits="TukiGestor.WebForm1" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <%: Styles.Render("~/Content/reportes") %>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">


    <div class="reporte-container">

        <div class="tabs-container">
            <h2 class="mb-4" style="color: #333; font-weight: bold;">
                <i class="bi bi-graph-up"></i>
                Reporte 
            </h2>
            <asp:UpdatePanel ID="UpdatePanelMensajes"  runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:Panel ID="pnlMensaje" ClientIDMode="Static" runat="server" Style="display:none;" CssClass="alert-custom">
                        <asp:Label ID="lblMensaje" runat="server"></asp:Label>
                    </asp:Panel>
                </ContentTemplate>
            </asp:UpdatePanel>
            <div>
                <ul class="nav nav-tabs" role="tablist">

                    <li class="nav-item">
                        <asp:LinkButton ID="btnTabMesas" runat="server" CssClass="nav-link active"
                            OnClick="btnTabMesas_Click">
            <i class="bi bi-fork-knife"></i> Mesas
                        </asp:LinkButton>
                    </li>

                    <li class="nav-item">
                        <asp:LinkButton ID="btnTabMeseros" runat="server" CssClass="nav-link"
                            OnClick="btnTabMeseros_Click">
            <i class="bi bi-person-circle"></i> Meseros
                        </asp:LinkButton>
                    </li>

                    <li class="nav-item">
                        <asp:LinkButton ID="btnTabProductos" runat="server" CssClass="nav-link"
                            OnClick="btnTabProductos_Click">
            <i class="bi bi-cup-straw"></i> Productos
                        </asp:LinkButton>
                    </li>

                    <li class="nav-item">
                        <asp:LinkButton ID="btnTabVentas" runat="server" CssClass="nav-link"
                            OnClick="btnTabVentas_Click">
            <i class="bi bi-receipt"></i> Ventas
                        </asp:LinkButton>
                    </li>

                    <li class="nav-item">
                        <asp:LinkButton ID="btnTabBalance" runat="server" CssClass="nav-link"
                            OnClick="btnTabBalance_Click">
            <i class="bi bi-book"></i> Balance
                        </asp:LinkButton>
                    </li>

                </ul>

            </div>


            <div class="options-container">
                <i class="bi bi-calendar-date calendario"></i>
                <div class="separador"></div>

                <!-- TURNO -->
                <div class="dropdown">
                    <asp:DropDownList ID="ddlTurno" CssClass="btn btn-secondary dropdown-toggle boton-turno" runat="server">
                        <asp:ListItem Text="Todos" Value="Todos" CssClass="dropdown-item items-turno"></asp:ListItem>
                        <asp:ListItem Text="Almuerzo" CssClass="dropdown-item items-turno" Value="Almuerzo"></asp:ListItem>
                        <asp:ListItem Text="Cena" CssClass="dropdown-item items-turno" Value="Cena"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <!-- RANGO -->
                <asp:DropDownList ID="ddlRango" CssClass="btn btn-secondary dropdown-toggle boton-rango"
                    runat="server" ClientIDMode="Static">
                    <asp:ListItem Text="Hoy" Value="Hoy" />
                    <asp:ListItem Text="Esta semana" Value="Semana" />
                    <asp:ListItem Text="Este Mes" Value="Mes" />
                    <asp:ListItem Text="Este Año" Value="Año" />
                    <asp:ListItem Text="Fechas personalizadas" Value="Personalizado" />
                </asp:DropDownList>


                <div class="separador"></div>

                <div class="date-selector-container">

                    <!-- selector personalizado -->
                    <div class="selector-rango">
                        <asp:TextBox ID="txtFechaDesde" runat="server"
                            CssClass="custom-datepicker"
                            TextMode="Date"
                            ClientIDMode="Static" />

                        <span class="fecha-hasta" id="fecha-hasta-label">hasta</span>

                        <asp:TextBox ID="txtFechaHasta" runat="server"
                            CssClass="custom-datepicker"
                            TextMode="Date"
                            ClientIDMode="Static" />
                    </div>
                </div>

                <!-- Botón Generar Balance (solo visible en pestaña Balance) -->
                <asp:Button ID="btnBuscarBalance" runat="server"
                    CssClass="btn btn-primary btn-lg px-4 boton-generar-balance"
                    Text="Generar Balance"
                    OnClick="btnBuscarBalance_Click"
                    ClientIDMode="Static"
                    Style="display: none; margin-left: auto;" />

            </div>


            <asp:Panel ID="pnlMesas" runat="server" CssClass="tab-pane fade active show">

                <!--   Pestaña Mesas -->

                    <div class="options-container-pestañas">

                        <!-- 1. Ranking (siempre es uno solo, pero mantenemos la UI) -->
                        <div class="dropdown">
                            <asp:DropDownList ID="ddlRankingMesas"
                                runat="server"
                                CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                                ClientIDMode="Static">
                                <asp:ListItem Text="Ranking de mesas" Value="Ranking" />
                            </asp:DropDownList>
                        </div>

                        <!-- Ubicación-->
                        <div class="dropdown">
                            <asp:DropDownList ID="ddlUbicacionMesas"
                                runat="server"
                                CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                                ClientIDMode="Static">
                                <asp:ListItem Text="Todas" Value="Todos" Selected="True" />
                                <asp:ListItem Text="Salón" Value="Salon" />
                                <asp:ListItem Text="Patio" Value="Patio" />
                            </asp:DropDownList>
                        </div>

                        <!-- Con más / Con menos -->
                        <div class="dropdown">
                            <asp:DropDownList ID="ddlCriterioOrdenMesas"
                                runat="server"
                                CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                                ClientIDMode="Static">
                                <asp:ListItem Text="Con más" Value="Mas" />
                                <asp:ListItem Text="Con menos" Value="Menos" />
                            </asp:DropDownList>
                        </div>

                        <!--  Facturación / Ocupación -->
                        <div class="dropdown">
                            <asp:DropDownList ID="ddlTipoBusqueda"
                                runat="server"
                                CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                                ClientIDMode="Static">
                                <asp:ListItem Text="Facturación" Value="Facturacion" />
                                <asp:ListItem Text="Ocupación" Value="Ocupacion" />
                            </asp:DropDownList>
                        </div>


                        <!-- buscar -->
                        <asp:Button ID="btnBuscarMesas"
                            runat="server"
                            Text="🔍 Buscar"
                            CssClass="btn btn-secondary boton-buscar"
                            OnClick="btnBuscarMesas_Click" />

                    </div>

            </asp:Panel>

            <asp:Panel ID="pnlMeseros" runat="server" CssClass="tab-pane fade">

                <!--  > Pestaña Meseros <!-->
                    <div class="options-container-pestañas">
                        <div class="dropdown">
                            <asp:DropDownList ID="ddlRankingMeseros"
                                runat="server"
                                CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                                ClientIDMode="Static">
                                <asp:ListItem Text="Ranking de meseros" Value="Ranking" />
                            </asp:DropDownList>
                        </div>

                        <!-- Ubicación-->
                        <div class="dropdown">
                            <asp:DropDownList ID="ddlUbicacionMeseros"
                                runat="server"
                                CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                                ClientIDMode="Static">
                                <asp:ListItem Text="Todas" Value="Todos" Selected="True" />
                                <asp:ListItem Text="Salón" Value="Salon" />
                                <asp:ListItem Text="Patio" Value="Patio" />
                            </asp:DropDownList>
                        </div>

                        <div class="dropdown">
                            <asp:DropDownList ID="ddlCriterioOrdenMeseros"
                                runat="server"
                                CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                                ClientIDMode="Static">
                                <asp:ListItem Text="Con más" Value="Mas" />
                                <asp:ListItem Text="Con menos" Value="Menos" />
                            </asp:DropDownList>
                        </div>

                        <div class="dropdown">
                            <asp:DropDownList ID="ddlCriterioBusquedaMeseros"
                                runat="server"
                                CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                                ClientIDMode="Static">
                                <asp:ListItem Text="Facturación" Value="Facturacion" />
                                <asp:ListItem Text="Mesas atendidas" Value="Mesas atendidas" />
                            </asp:DropDownList>
                        </div>
                        <asp:Button ID="btnMeserosBuscar"
                            runat="server"
                            Text="🔍 Buscar"
                            CssClass="btn btn-secondary boton-buscar"
                            OnClick="btnMeserosBuscar_Click" />


                    </div>
                


            </asp:Panel>

            <asp:Panel ID="pnlProductos" runat="server" CssClass="tab-pane fade ">

                <div class="options-container-pestañas">

                    <!-- 1. Ranking -->
                    <div class="dropdown">
                        <asp:DropDownList ID="ddlRankingProductos"
                            runat="server"
                            CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                            ClientIDMode="Static">
                            <asp:ListItem Text="Ranking productos" Value="Ranking" />
                        </asp:DropDownList>
                    </div>

                     <div class="dropdown">
     <asp:DropDownList ID="ddlUbicacionProductos"
         runat="server"
         CssClass="btn btn-secondary dropdown-toggle boton-ranking"
         ClientIDMode="Static">
         <asp:ListItem Text="Todas" Value="Todos" Selected="True" />
         <asp:ListItem Text="Salón" Value="Salon" />
         <asp:ListItem Text="Patio" Value="Patio" />
     </asp:DropDownList>
 </div>

                    <div class="dropdown">
                        <asp:DropDownList ID="ddlCantidadProductos"
                            runat="server"
                            CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                            ClientIDMode="Static">
                            <asp:ListItem Text="10 Productos" Value="10" />
                            <asp:ListItem Text="20 Productos" Value="20" />
                            <asp:ListItem Text="30 Productos" Value="30" />
                            <asp:ListItem Text="40 Productos" Value="40" />
                            <asp:ListItem Text="50 Productos" Value="50" />
                        </asp:DropDownList>
                    </div>

                    <div class="dropdown">
                        <asp:DropDownList ID="ddlCriterioOrdenProductos"
                            runat="server"
                            CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                            ClientIDMode="Static">
                            <asp:ListItem Text="Con más" Value="Mas" />
                            <asp:ListItem Text="Con menos" Value="Menos" />
                        </asp:DropDownList>
                    </div>

                    <div class="dropdown">
                        <asp:DropDownList ID="ddlCriterioBusquedaProductos"
                            runat="server"
                            CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                            ClientIDMode="Static">
                            <asp:ListItem Text="Facturación" Value="Facturacion" />
                            <asp:ListItem Text="Ventas" Value="Ventas" />
                        </asp:DropDownList>
                    </div>

                    <div class="dropdown">
                        <asp:DropDownList ID="ddlCategoriaProductos"
                            runat="server"
                            CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                            ClientIDMode="Static">
                             <asp:ListItem Text="Todas" Value="Todos" Selected="True" />
                            <asp:ListItem Text="Platos Principales" Value="Comida" />
                            <asp:ListItem Text="Bebidas" Value="Bebidas" />
                            <asp:ListItem Text="Postres" Value="Postres" />
                            
                        </asp:DropDownList>
                    </div>

                    <asp:Button
                        ID="btnBuscarProductos"
                        runat="server"
                        Text="🔍 Buscar"
                        CssClass="btn btn-secondary boton-buscar"
                        onclick="btnBuscarProductos_Click" />
                </div>

            </asp:Panel>

                        <asp:Panel ID="pnlVentas" runat="server" CssClass="tab-pane fade">


                <div class="options-container-pestañas">

                    <!-- Ubicación-->
                    <div class="dropdown">
                        <asp:DropDownList ID="ddlUbicacionVentas"
                            runat="server"
                            CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                            ClientIDMode="Static">
                            <asp:ListItem Text="Ubicación" Value="" Disabled="True" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Todas" Value="Todos" />
                            <asp:ListItem Text="Salón" Value="Salon" />
                            <asp:ListItem Text="Patio" Value="Patio" />
                            <asp:ListItem Text="Mostrador" Value="Mostrador" />
                        </asp:DropDownList>
                    </div>

                    <!-- Tipo de Pago -->
                    <div class="dropdown">
                        <asp:DropDownList ID="ddlTipoPagoVentas"
                            runat="server"
                            CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                            ClientIDMode="Static">
                            <asp:ListItem Text="Tipo de pago" Value="" Disabled="True" Selected="True" />
                            <asp:ListItem Text="Todos" Value="Todos" />
                            <asp:ListItem Text="Efectivo" Value="Efectivo" />
                            <asp:ListItem Text="Tarjeta de Crédito" Value="Tarjeta de Credito" />
                            <asp:ListItem Text="Transferencia" Value="Transferencia" />
                        </asp:DropDownList>
                    </div>

                    <!-- Botón Buscar -->
                    <asp:Button ID="btnBuscarVentas"
                        runat="server"
                        Text="🔍 Buscar"
                        CssClass="btn btn-secondary boton-buscar"
                        OnClick="btnBuscarVentas_Click" />
                </div>

                        </asp:Panel>

                        <asp:Panel ID="pnlBalance" runat="server" CssClass="tab-pane fade">
                            <div class="balance-container-scroll">

                                <!-- Tarjetas de métricas principales -->
                                <div class="row g-4 mb-4">
                                    <div class="col-md-3">
                                        <div class="metric-card">
                                            <h6 class="metric-label">
                                                <i class="bi bi-cash-stack me-2"></i>Total Ventas
                                            </h6>
                                            <h3 class="metric-value">
                                                <asp:Label ID="lblTotalVentas" runat="server" Text="$0.00"></asp:Label>
                                            </h3>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="metric-card">
                                            <h6 class="metric-label">
                                                <i class="bi bi-receipt me-2"></i>Cantidad de Ventas
                                            </h6>
                                            <h3 class="metric-value">
                                                <asp:Label ID="lblCantidadVentas" runat="server" Text="0"></asp:Label>
                                            </h3>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="metric-card">
                                            <h6 class="metric-label">
                                                <i class="bi bi-people-fill me-2"></i>Clientes Atendidos
                                            </h6>
                                            <h3 class="metric-value">
                                                <asp:Label ID="lblCantidadClientes" runat="server" Text="0"></asp:Label>
                                            </h3>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="metric-card">
                                            <h6 class="metric-label">
                                                <i class="bi bi-box-seam me-2"></i>Productos Vendidos
                                            </h6>
                                            <h3 class="metric-value">
                                                <asp:Label ID="lblProductosVendidos" runat="server" Text="0"></asp:Label>
                                            </h3>
                                        </div>
                                    </div>
                                </div>

                                <!-- Gráficos -->
                                <div class="row g-4">
                                    <!-- Gráfico de Torta - Ventas por Forma de Pago -->
                                    <div class="col-md-7">
                                        <div class="chart-card">
                                            <h5 class="chart-title">
                                                <i class="bi bi-pie-chart-fill"></i>
                                                Ventas por Forma de Pago
                                            </h5>
                                            <div class="chart-container">
                                                <canvas id="chartFormaPago"></canvas>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Tabla de Formas de Pago -->
                                    <div class="col-md-5">
                                        <div class="chart-card">
                                            <h5 class="chart-title">
                                                <i class="bi bi-table"></i>
                                                Detalle por Forma de Pago
                                            </h5>
                                            <div class="table-responsive">
                                                <asp:GridView ID="gvFormaPago" runat="server"
                                                    AutoGenerateColumns="False"
                                                    CssClass="table table-hover"
                                                    HeaderStyle-CssClass="table-dark"
                                                    EmptyDataText="No hay datos para mostrar."
                                                    GridLines="None">
                                                    <Columns>
                                                        <asp:BoundField DataField="FormaPago" HeaderText="Forma de Pago" />
                                                        <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" />
                                                        <asp:TemplateField HeaderText="Monto">
                                                            <ItemTemplate>
                                                                <%# String.Format("${0:N2}", Eval("Monto")) %>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Porcentaje">
                                                            <ItemTemplate>
                                                                <span class="fw-bold"><%# String.Format("{0:N1}%", Eval("Porcentaje")) %></span>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </asp:GridView>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Hidden fields para datos del gráfico -->
                                <asp:HiddenField ID="hfFormaPagoLabels" runat="server" ClientIDMode="Static" />
                                <asp:HiddenField ID="hfFormaPagoData" runat="server" ClientIDMode="Static" />
                                <asp:HiddenField ID="hfFormaPagoColors" runat="server" ClientIDMode="Static" />
                            </div>
                        </asp:Panel>


            <asp:Panel ID="pnlResultadoMesas" runat="server" ClientIDMode="Static" Visible="false" UpdateMode="Conditional">

                <asp:GridView ID="gvMesas" runat="server"
                    AutoGenerateColumns="False"
                    CssClass="table table-striped table-hover text-center shadow-lg"
                    HeaderStyle-CssClass="table-dark"
                    EmptyDataText="No hay resultados para mostrar."
                    GridLines="None">
                    <Columns>
                        <asp:BoundField
                            DataField="NumeroMesa"
                            HeaderText="Mesa"
                            SortExpression="NumeroMesa" />

                        <asp:BoundField
                            DataField="Ubicacion"
                            HeaderText="Ubicación"
                            SortExpression="Ubicacion" />

                        <asp:BoundField
                            DataField="Facturacion"
                            HeaderText="Facturación"
                            DataFormatString="{0:C}"
                            HtmlEncode="false"
                            SortExpression="Facturacion" />

                        <asp:BoundField
                            DataField="Ocupacion"
                            HeaderText="Ocupación"
                            SortExpression="Ocupacion" />

                    </Columns>
                </asp:GridView>
              </asp:Panel>

            <asp:Panel ID="PnlResultadoMeseros" runat="server" ClientIDMode="Static" Visible="false" UpdateMode="Conditional">
                <asp:GridView ID="gvMeseros" runat="server"
                    AutoGenerateColumns="False"
                    CssClass="table table-striped table-hover text-center shadow-lg"
                    HeaderStyle-CssClass="table-dark"
                    EmptyDataText="No hay resultados para mostrar."
                    GridLines="None">
                    <Columns>
                        <asp:BoundField
                            DataField="NombreApellido"
                            HeaderText="Mesero"
                            SortExpression="NumeroMesa" />

                        <asp:BoundField
                            DataField="Facturacion"
                            HeaderText="Facturación"
                            DataFormatString="{0:C}"
                            HtmlEncode="false"
                            SortExpression="Facturacion" />

                        <asp:BoundField
                            DataField="MesasAtendidas"
                            HeaderText="Mesas Atendidas"
                            SortExpression="MesasAtendidas" />

                    </Columns>
                </asp:GridView>
            </asp:Panel>


            <asp:Panel ID="pnlResultadosProductos" runat="server" ClientIDMode="Static" Visible="false" UpdateMode="Conditional">
                <asp:GridView ID="gvProductos" runat="server"
                    AutoGenerateColumns="False"
                    CssClass="table table-striped table-hover text-center shadow-lg"
                    HeaderStyle-CssClass="table-dark"
                    EmptyDataText="No hay resultados para mostrar."
                    GridLines="None">
                    <Columns>
                        <asp:BoundField
                            DataField="NombreProducto"
                            HeaderText="Producto"
                            SortExpression="NombreProducto" />
                        <asp:BoundField
                            DataField="Categoria"
                            HeaderText="Categoría"
                            SortExpression="Categoria" />

                        <asp:BoundField
                            DataField="Facturacion"
                            HeaderText="Facturación"
                            DataFormatString="{0:C}"
                            HtmlEncode="false"
                            SortExpression="Facturacion" />

                        <asp:BoundField
                            DataField="CantidadVendida"
                            HeaderText="Cantidad vendida"
                            SortExpression="CantidadVendida" />

                    </Columns>
                </asp:GridView>
            </asp:Panel>

            <asp:Panel ID="pnlResultadosVentas" runat="server" ClientIDMode="Static" Visible="false" UpdateMode="Conditional">
                <asp:GridView ID="gvVentas" runat="server"
                    AutoGenerateColumns="False"
                    CssClass="table table-striped table-hover text-center shadow-lg"
                    HeaderStyle-CssClass="table-dark"
                    EmptyDataText="No hay resultados para mostrar."
                    GridLines="None"
                    OnRowCommand="gvVentas_RowCommand">
                    <Columns>
                        <asp:TemplateField HeaderText="Acciones">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnVerDetalle" runat="server"
                                    CssClass="btn btn-sm"
                                    Style="background-color: #E7D9C2; color: #333; border: none; font-weight: 600;"
                                    CommandName="VerDetalle"
                                    CommandArgument='<%# Eval("VentaId") %>'
                                    ToolTip="Ver detalle de venta">
                                    <i class="bi bi-eye-fill"></i> Ver Detalle
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField
                            DataField="Fecha"
                            HeaderText="Fecha"
                            DataFormatString="{0:dd/MM/yyyy HH:mm}"
                            HtmlEncode="false"
                            SortExpression="Fecha" />

                        <asp:BoundField
                            DataField="NumeroMesa"
                            HeaderText="Mesa"
                            SortExpression="NumeroMesa" />

                        <asp:BoundField
                            DataField="Mesero"
                            HeaderText="Mesero"
                            SortExpression="Mesero" />

                        <asp:BoundField
                            DataField="TipoPago"
                            HeaderText="Tipo de Pago"
                            SortExpression="TipoPago" />

                        <asp:BoundField
                            DataField="MontoTotal"
                            HeaderText="Monto Total"
                            DataFormatString="{0:C}"
                            HtmlEncode="false"
                            SortExpression="MontoTotal" />

                        <asp:BoundField
                            DataField="Turno"
                            HeaderText="Turno"
                            SortExpression="Turno" />

                    </Columns>
                </asp:GridView>
            </asp:Panel>


        </div>
    </div>

    <!-- Modal Detalle de Venta -->
    <div class="modal fade" id="modalDetalleVenta" tabindex="-1" aria-labelledby="modalDetalleVentaLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content" style="border-radius: 15px; overflow: hidden; border: 2px solid #E7D9C2;">
                <div class="modal-header" style="background: #E7D9C2; border: none; padding: 25px;">
                    <div>
                        <h4 class="modal-title mb-1" id="modalDetalleVentaLabel" style="color: #333;">
                            <i class="bi bi-receipt-cutoff"></i> Detalle de Venta
                        </h4>
                        <p class="mb-0" style="font-size: 14px; color: #666;">Venta #<span id="modalVentaId"></span></p>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" style="padding: 30px; background: #F6EFE0;">
                    <!-- Información General -->
                    <div class="card shadow-sm mb-3" style="border: 1px solid #C19A6B; border-radius: 12px; background: white;">
                        <div class="card-body" style="padding: 20px;">
                            <h6 class="card-title mb-3" style="color: #333; font-weight: bold; font-size: 16px;">
                                <i class="bi bi-info-circle-fill" style="color: #C19A6B;"></i> Información General
                            </h6>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <div style="background: #E7D9C2; padding: 12px; border-radius: 8px;">
                                        <small class="text-muted d-block mb-1" style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px;">Fecha y Hora</small>
                                        <div id="modalVentaFecha" style="font-weight: 600; color: #333; font-size: 14px;"></div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div style="background: #E7D9C2; padding: 12px; border-radius: 8px;">
                                        <small class="text-muted d-block mb-1" style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px;">Ubicación</small>
                                        <div id="modalVentaUbicacion" style="font-weight: 600; color: #333; font-size: 14px;"></div>
                                    </div>
                                </div>
                                <div class="col-md-6" id="divVentaMesero" style="display: none;">
                                    <div style="background: #E7D9C2; padding: 12px; border-radius: 8px;">
                                        <small class="text-muted d-block mb-1" style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px;">Mesero</small>
                                        <div id="modalVentaMesero" style="font-weight: 600; color: #333; font-size: 14px;"></div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div style="background: #E7D9C2; padding: 12px; border-radius: 8px;">
                                        <small class="text-muted d-block mb-1" style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px;">Tipo de Pago</small>
                                        <div id="modalVentaTipoPago" style="font-weight: 600; color: #333; font-size: 14px;"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Productos Vendidos -->
                    <div class="card shadow-sm mb-3" style="border: 1px solid #E7D9C2; border-radius: 12px; background: white;">
                        <div class="card-body" style="padding: 20px;">
                            <h6 class="card-title mb-3" style="color: #333; font-weight: bold; font-size: 16px;">
                                <i class="bi bi-cart-check-fill" style="color: #C19A6B;"></i> Productos Vendidos
                            </h6>
                            <div id="modalVentaProductos" style="max-height: 300px; overflow-y: auto;">
                                <!-- Se llenara desde el servidor -->
                            </div>
                        </div>
                    </div>

                    <!-- Total -->
                    <div class="card shadow-sm" style="border: 2px solid #E7D9C2; border-radius: 12px; background: #E7D9C2;">
                        <div class="card-body text-center" style="padding: 20px;">
                            <p class="mb-2" style="font-size: 14px; color: #666; text-transform: uppercase; letter-spacing: 1px; font-weight: 600;">Total de la Venta</p>
                            <h2 id="modalVentaTotal" class="mb-0" style="font-size: 36px; font-weight: bold; color: #8B7355;">$0</h2>
                        </div>
                    </div>
                </div>
                <div class="modal-footer" style="background: #F6EFE0; border-top: 1px solid #E7D9C2; padding: 20px;">
                    <button type="button" class="btn px-4" data-bs-dismiss="modal" style="background: #E7D9C2; color: #333; font-weight: 600; border: none;">
                        <i class="bi bi-x-circle"></i> Cerrar
                    </button>
                </div>
            </div>
        </div>
    </div>




    <script>     

        const ddlRango = document.getElementById('ddlRango');
        const itemsTurno = document.querySelectorAll(".items-turno");
        const botonTurno = document.querySelector('.boton-turno');
        const botonRango = document.querySelector('.boton-rango');
        const selectorRango = document.querySelector(".selector-rango");

        ddlRango.addEventListener("change", function () {

            const rangoElegido = ddlRango.value;

            switch (rangoElegido) {


                case "Personalizado":

                    selectorRango.style.display = "flex";
                    break;

                default:
                    selectorRango.style.display = "none";
                    break;
            }
        })


        document.querySelectorAll('[data-bs-toggle="tab"]').forEach(tab => {
            tab.addEventListener("shown.bs.tab", (event)=> {
                // Oculta todos los resultados de reportes
                document.getElementById("pnlResultadoMesas").style.display = "none";
                //document.getElementById("panelMeseros").style.display = "none";
                //document.getElementById("panelProductos").style.display = "none";
                //document.getElementById("panelVentas").style.display = "none";
                //document.getElementById("panelBalance").style.display = "none";

                const panel = document.getElementById("pnlMensaje");
                if (panel) {
                    panel.style.display = "none";
                    panel.classList.remove("alert-show");
                }

                // Mostrar/ocultar botón Generar Balance según la pestaña activa
                const botonBalance = document.getElementById("btnBuscarBalance");
                if (botonBalance) {
                    // Verificar si el tab activo es el de Balance
                    const tabId = event.target.id || event.target.getAttribute('id');
                    if (tabId && tabId.includes('Balance')) {
                        botonBalance.style.display = "block";
                    } else {
                        botonBalance.style.display = "none";
                    }
                }

            });
        });

        // Verificar pestaña activa al cargar la página
        window.addEventListener('DOMContentLoaded', function() {
            const botonBalance = document.getElementById("btnBuscarBalance");
            if (botonBalance) {
                // Verificar qué tab está activo
                const activeTab = document.querySelector('.nav-link.active');
                if (activeTab && activeTab.id && activeTab.id.includes('Balance')) {
                    botonBalance.style.display = "block";
                } else {
                    botonBalance.style.display = "none";
                }
            }
        });



        // Chart.js - Gráfico de Torta para Forma de Pago
        let chartFormaPago = null;

        function renderizarGraficoFormaPago() {
            const labels = document.getElementById('hfFormaPagoLabels');
            const data = document.getElementById('hfFormaPagoData');
            const colors = document.getElementById('hfFormaPagoColors');

            if (!labels || !data || !labels.value || !data.value) {
                return;
            }

            const labelsArray = JSON.parse(labels.value);
            const dataArray = JSON.parse(data.value);
            const colorsArray = JSON.parse(colors.value);

            const ctx = document.getElementById('chartFormaPago');
            if (!ctx) return;

            // Destruir gráfico anterior si existe
            if (chartFormaPago) {
                chartFormaPago.destroy();
            }

            chartFormaPago = new Chart(ctx, {
                type: 'pie',
                data: {
                    labels: labelsArray,
                    datasets: [{
                        data: dataArray,
                        backgroundColor: colorsArray,
                        borderWidth: 2,
                        borderColor: '#fff'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                padding: 8,
                                font: {
                                    size: 10,
                                    family: 'Segoe UI'
                                },
                                boxWidth: 12
                            }
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    let label = context.label || '';
                                    if (label) {
                                        label += ': ';
                                    }
                                    label += '$' + context.parsed.toFixed(2);
                                    return label;
                                }
                            }
                        }
                    }
                }
            });
        }

        // Ejecutar cuando se carga la página o después de un postback
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', renderizarGraficoFormaPago);
        } else {
            renderizarGraficoFormaPago();
        }

        // Re-renderizar después de un postback de ASP.NET
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function() {
            setTimeout(renderizarGraficoFormaPago, 100);
        });

    </script>

    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

</asp:Content>


