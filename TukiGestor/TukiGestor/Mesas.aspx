<%@ Page Title="Mesas" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Mesas.aspx.cs" Inherits="TukiGestor.Mesas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .mesas-container {
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

        .sidebar.collapsed ~ .main-wrapper .mesas-container {
            left: calc(50vw + 40px);
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

        .nav-tabs .nav-link:hover {
            background-color: #E7D9C2;
            color: #333;
        }

        .nav-tabs .nav-link.active {
            background-color: #E7D9C2;
            color: #333;
            border: none;
        }

        .tab-pane {
            display: none;
            opacity: 0;
            transition: opacity 0.2s ease;
            max-height: calc(80vh - 150px);
            overflow-y: auto;
            padding-right: 10px;
        }

        .tab-pane.active.show {
            display: block;
            opacity: 1;
        }

        /* Estilos para el scrollbar */
        .tab-pane::-webkit-scrollbar {
            width: 8px;
        }

        .tab-pane::-webkit-scrollbar-track {
            background: #F6EFE0;
            border-radius: 10px;
        }

        .tab-pane::-webkit-scrollbar-thumb {
            background: #E7D9C2;
            border-radius: 10px;
        }

        .tab-pane::-webkit-scrollbar-thumb:hover {
            background: #d4c5ae;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .section-title {
            font-size: 24px;
            font-weight: bold;
            color: #333;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
        }

        .mesas-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
            max-height: calc(80vh - 250px);
            overflow-y: auto;
            padding-right: 10px;
        }

        .mesas-grid::-webkit-scrollbar {
            width: 8px;
        }

        .mesas-grid::-webkit-scrollbar-track {
            background: #F6EFE0;
            border-radius: 10px;
        }

        .mesas-grid::-webkit-scrollbar-thumb {
            background: #E7D9C2;
            border-radius: 10px;
        }

        .mesas-grid::-webkit-scrollbar-thumb:hover {
            background: #d4c5ae;
        }

        .mesa-card {
            background: #F6EFE0;
            border: 2px solid #E7D9C2;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            position: relative;
            display: flex !important;
            align-items: center;
            justify-content: center;
            text-decoration: none !important;
            color: inherit !important;
            min-height: 140px;
        }

        a.mesa-card {
            display: flex !important;
        }

        a.mesa-card:hover {
            text-decoration: none !important;
            color: inherit !important;
        }

        a.mesa-card:focus {
            text-decoration: none !important;
            color: inherit !important;
            outline: none;
        }

        .mesa-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
        }

        .mesa-card .mesa-icon {
            font-size: 80px;
            transition: all 0.3s ease;
            position: relative;
        }

        .mesa-card.libre .mesa-icon {
            color: #28a745;
        }

        .mesa-card.ocupada .mesa-icon {
            color: #dc3545;
        }

        .mesa-card .mesa-number {
            position: absolute;
            font-size: 28px;
            font-weight: bold;
            color: #fff;
            text-shadow: 0 0 3px rgba(0, 0, 0, 0.5);
            z-index: 1;
        }

        .delete-btn {
            position: absolute;
            top: 5px;
            right: 5px;
            background: #dc3545;
            color: white;
            border: none;
            border-radius: 50%;
            width: 25px;
            height: 25px;
            font-size: 16px;
            cursor: pointer;
            display: none !important;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            z-index: 10;
            text-decoration: none !important;
        }

        .mesas-grid > div:hover .delete-btn {
            display: flex !important;
        }

        .delete-btn:hover {
            background: #c82333 !important;
            transform: scale(1.1);
            color: white !important;
            text-decoration: none !important;
        }

        a.delete-btn {
            display: none !important;
            text-decoration: none !important;
        }

        .mesas-grid > div:hover a.delete-btn {
            display: flex !important;
        }

        .add-mesa-card {
            background: #F6EFE0;
            border: 2px dashed #E7D9C2;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            display: flex !important;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 140px;
            text-decoration: none !important;
            color: inherit !important;
        }

        a.add-mesa-card {
            display: flex !important;
        }

        .add-mesa-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
            background: #E7D9C2;
            text-decoration: none !important;
            color: inherit !important;
        }

        .add-mesa-card:focus {
            text-decoration: none !important;
            color: inherit !important;
            outline: none;
        }

        .add-mesa-card i {
            font-size: 50px;
            color: #28a745;
            margin-bottom: 10px;
        }


        .modal-content {
            border-radius: 15px;
            border: none;
            background-color: #F6EFE0;
        }

        .modal-header {
            background-color: #E7D9C2;
            border-radius: 15px 15px 0 0;
            border-bottom: none;
            padding: 20px 30px;
        }

        .modal-title {
            font-weight: bold;
            color: #333;
        }

        .modal-body {
            padding: 30px;
            background-color: #F6EFE0;
            border-radius: 0 0 15px 15px;
        }

        /* Modal de Orden con altura fija y scroll completo */
        #modalOrden .modal-body {
            max-height: 75vh;
            overflow-y: auto;
            overflow-x: hidden;
        }

        /* Asegurar que el resumen tenga altura fija y scroll independiente */
        #modalOrden .orden-resumen {
            max-height: 350px;
        }

        .form-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }

        .form-control, .form-select {
            border: 2px solid #E7D9C2;
            border-radius: 8px;
            padding: 10px 15px;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: #d4c5ae;
            box-shadow: 0 0 0 3px rgba(231, 217, 194, 0.2);
        }

        .btn-abrir-mesa {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: 600;
            width: 100%;
            transition: all 0.3s ease;
        }

        .btn-abrir-mesa:hover {
            background-color: #218838;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
        }

        .btn-abrir-mesa:active {
            background-color: #1e7e34;
        }

        .producto-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 15px;
            background: #F6EFE0;
            border-radius: 8px;
            margin-bottom: 10px;
            transition: all 0.3s ease;
        }

        .producto-item:hover {
            background: #E7D9C2;
        }

        .producto-item:active {
            background: #E7D9C2;
        }

        .producto-info {
            flex: 1;
        }

        .producto-nombre {
            font-weight: 600;
            color: #333;
            margin-bottom: 3px;
        }

        .producto-precio {
            color: #666;
            font-size: 14px;
        }

        .cantidad-control {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .cantidad-control button {
            background: #E7D9C2;
            border: none;
            width: 30px;
            height: 30px;
            border-radius: 5px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .cantidad-control button:hover {
            background: #d4c5ae;
        }

        .cantidad-control button:active {
            background: #d4c5ae;
        }

        .cantidad-control input {
            width: 50px;
            text-align: center;
            border: 2px solid #E7D9C2;
            border-radius: 5px;
            padding: 5px;
        }

        .orden-resumen {
            background: #F6EFE0;
            padding: 20px;
            border-radius: 10px;
            margin-top: 20px;
            max-height: 400px;
            display: flex;
            flex-direction: column;
        }

        .orden-resumen h6 {
            flex-shrink: 0;
            margin-bottom: 15px;
        }

        .orden-resumen #resumenOrden {
            overflow-y: auto;
            flex-grow: 1;
            max-height: 280px;
            margin-bottom: 15px;
            padding-right: 5px;
        }

        .orden-resumen .orden-total {
            flex-shrink: 0;
            margin-top: auto;
        }

        .orden-total {
            display: flex;
            justify-content: space-between;
            font-size: 20px;
            font-weight: bold;
            color: #333;
            padding-top: 15px;
            border-top: 2px solid #E7D9C2;
            margin-top: 15px;
        }

        .empty-state {
            text-align: center;
            padding: 40px;
            color: #999;
        }

        .empty-state i {
            font-size: 60px;
            margin-bottom: 15px;
        }

        .resumen-completo {
            max-height: 400px;
            overflow-y: auto;
            padding: 10px;
        }

        .resumen-item {
            display: flex;
            justify-content: space-between;
            padding: 15px;
            background: #F6EFE0;
            border-radius: 8px;
            margin-bottom: 10px;
            align-items: center;
        }

        .resumen-item-info {
            flex: 1;
        }

        .resumen-item-nombre {
            font-weight: 600;
            color: #333;
            font-size: 16px;
            margin-bottom: 3px;
        }

        .resumen-item-cantidad {
            color: #666;
            font-size: 14px;
        }

        .resumen-item-precio {
            font-weight: bold;
            color: #333;
            font-size: 18px;
        }

        .btn-success:active {
            background-color: #1e7e34;
            border-color: #1c7430;
        }

        .btn-secondary:active {
            background-color: #5a6268;
            border-color: #545b62;
        }

        #ordenes-mostrador-container {
            margin-top: 20px;
            max-height: calc(80vh - 250px);
            overflow-y: auto;
            padding-right: 10px;
        }

        #ordenes-mostrador-container::-webkit-scrollbar {
            width: 8px;
        }

        #ordenes-mostrador-container::-webkit-scrollbar-track {
            background: #F6EFE0;
            border-radius: 10px;
        }

        #ordenes-mostrador-container::-webkit-scrollbar-thumb {
            background: #E7D9C2;
            border-radius: 10px;
        }

        #ordenes-mostrador-container::-webkit-scrollbar-thumb:hover {
            background: #d4c5ae;
        }

        .orden-mostrador-card {
            display: block;
            background: #F6EFE0;
            border: 2px solid #E7D9C2;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            text-decoration: none;
            color: inherit;
        }

        .orden-mostrador-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            text-decoration: none;
            color: inherit;
        }

        .orden-mostrador-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #E7D9C2;
        }

        .orden-mostrador-id {
            font-size: 18px;
            font-weight: bold;
            color: #333;
        }

        .orden-mostrador-fecha {
            font-size: 14px;
            color: #666;
        }

        .orden-mostrador-productos {
            margin-bottom: 10px;
        }

        .orden-mostrador-producto {
            display: flex;
            justify-content: space-between;
            padding: 5px 0;
            color: #333;
        }

        .orden-mostrador-total {
            font-size: 20px;
            font-weight: bold;
            color: #28a745;
            text-align: right;
            margin-top: 10px;
            padding-top: 10px;
            border-top: 2px solid #E7D9C2;
        }

        .empty-ordenes {
            text-align: center;
            padding: 40px;
            color: #999;
            font-style: italic;
        }

        /* Estilos para tabs de categorias de productos */
        .categorias-tabs {
            margin-bottom: 20px;
        }

        .categorias-tabs .nav-link {
            color: #666;
            border: 2px solid #E7D9C2;
            background: #F6EFE0;
            margin-right: 10px;
            border-radius: 8px;
            padding: 8px 20px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .categorias-tabs .nav-link:hover {
            background: #E7D9C2;
            color: #333;
        }

        .categorias-tabs .nav-link.active {
            background: #28a745;
            color: white;
            border-color: #28a745;
        }

        .productos-lista {
            max-height: 300px;
            overflow-y: auto;
            margin-bottom: 15px;
        }

        /* Notificaciones flotantes */
        .toast-notification {
            position: fixed;
            top: 20px;
            right: 20px;
            background: white;
            padding: 20px 25px;
            border-radius: 12px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.2);
            z-index: 10000;
            min-width: 300px;
            max-width: 400px;
            animation: slideInRight 0.3s ease-out;
            display: flex;
            align-items: center;
            gap: 15px;
            border-left: 5px solid;
        }

        .toast-notification.success {
            border-left-color: #28a745;
        }

        .toast-notification.error {
            border-left-color: #dc3545;
        }

        .toast-notification.warning {
            border-left-color: #ffc107;
        }

        .toast-notification.info {
            border-left-color: #17a2b8;
        }

        .toast-notification .toast-icon {
            font-size: 28px;
        }

        .toast-notification.success .toast-icon {
            color: #28a745;
        }

        .toast-notification.error .toast-icon {
            color: #dc3545;
        }

        .toast-notification.warning .toast-icon {
            color: #ffc107;
        }

        .toast-notification.info .toast-icon {
            color: #17a2b8;
        }

        .toast-notification .toast-content {
            flex: 1;
        }

        .toast-notification .toast-title {
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
            font-size: 16px;
        }

        .toast-notification .toast-message {
            color: #666;
            font-size: 14px;
        }

        .toast-notification .toast-close {
            background: none;
            border: none;
            font-size: 20px;
            color: #999;
            cursor: pointer;
            padding: 0;
            line-height: 1;
        }

        .toast-notification .toast-close:hover {
            color: #333;
        }

        @keyframes slideInRight {
            from {
                transform: translateX(400px);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        @keyframes slideOutRight {
            from {
                transform: translateX(0);
                opacity: 1;
            }
            to {
                transform: translateX(400px);
                opacity: 0;
            }
        }

        .toast-notification.closing {
            animation: slideOutRight 0.3s ease-out forwards;
        }

        /* Modal de confirmación personalizado */
        .custom-confirm-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 9999;
            display: flex;
            align-items: center;
            justify-content: center;
            animation: fadeIn 0.2s ease-out;
        }

        .custom-confirm-box {
            background: #F6EFE0;
            border-radius: 15px;
            padding: 30px;
            max-width: 400px;
            width: 90%;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
            animation: scaleIn 0.3s ease-out;
        }

        .custom-confirm-icon {
            text-align: center;
            font-size: 50px;
            margin-bottom: 20px;
            color: #ffc107;
        }

        .custom-confirm-title {
            text-align: center;
            font-size: 20px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }

        .custom-confirm-message {
            text-align: center;
            color: #666;
            margin-bottom: 25px;
            line-height: 1.5;
        }

        .custom-confirm-buttons {
            display: flex;
            gap: 10px;
        }

        .custom-confirm-btn {
            flex: 1;
            padding: 12px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .custom-confirm-btn.confirm {
            background: #dc3545;
            color: white;
        }

        .custom-confirm-btn.confirm:hover {
            background: #c82333;
            transform: translateY(-2px);
        }

        .custom-confirm-btn.cancel {
            background: #6c757d;
            color: white;
        }

        .custom-confirm-btn.cancel:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes scaleIn {
            from {
                transform: scale(0.9);
                opacity: 0;
            }
            to {
                transform: scale(1);
                opacity: 1;
            }
        }

        .mensaje-info {
            text-align: center;
            padding: 40px;
            color: #666;
            font-style: italic;
        }
    </style>

    <div class="mesas-container">
        <div class="tabs-container">
            <h2 class="mb-4" style="color: #333; font-weight: bold;">
                <i class="bi bi-grid-3x3"></i> Gestion de Mesas
            </h2>

            <!-- Mensaje de notificación -->
            <asp:Panel ID="PanelMensaje" runat="server" Visible="false" CssClass="alert alert-dismissible fade show" role="alert">
                <asp:Literal ID="LitMensaje" runat="server"></asp:Literal>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </asp:Panel>

            <!-- Tabs Navigation - Clases CSS generadas desde C# -->
            <asp:HiddenField ID="HdnTabActivo" runat="server" Value="salon" />
            <ul class="nav nav-tabs" id="mesasTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link <%= HdnTabActivo.Value == "salon" || string.IsNullOrEmpty(HdnTabActivo.Value) ? "active" : "" %>"
                            id="salon-tab" data-bs-toggle="tab" data-bs-target="#salon" type="button" role="tab"
                            onclick="document.getElementById('<%= HdnTabActivo.ClientID %>').value='salon'">
                        <i class="bi bi-house-door"></i> Salon
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link <%= HdnTabActivo.Value == "patio" ? "active" : "" %>"
                            id="patio-tab" data-bs-toggle="tab" data-bs-target="#patio" type="button" role="tab"
                            onclick="document.getElementById('<%= HdnTabActivo.ClientID %>').value='patio'">
                        <i class="bi bi-tree"></i> Patio
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link <%= HdnTabActivo.Value == "mostrador" ? "active" : "" %>"
                            id="mostrador-tab" data-bs-toggle="tab" data-bs-target="#mostrador" type="button" role="tab"
                            onclick="document.getElementById('<%= HdnTabActivo.ClientID %>').value='mostrador'">
                        <i class="bi bi-shop"></i> Mostrador
                    </button>
                </li>
            </ul>

            <!-- Tabs Content - Clases CSS generadas desde C# -->
            <div class="tab-content" id="mesasTabContent">
                <!-- Salón Tab -->
                <div class="tab-pane fade <%= (HdnTabActivo.Value == "salon" || string.IsNullOrEmpty(HdnTabActivo.Value)) ? "show active" : "" %>" id="salon" role="tabpanel">
                    <div class="section-header">
                        <div class="section-title">Mesas del Salon</div>
                    </div>
                    <div class="mesas-grid">
                        <asp:Repeater ID="RepMesasSalon" runat="server">
                            <ItemTemplate>
                                <div style="position: relative;">
                                    <asp:LinkButton ID="LnkMesa" runat="server"
                                        CssClass='<%# "mesa-card " + ((string)Eval("Estado")).ToLower() %>'
                                        CommandArgument='<%# Eval("MesaId") + "|" + Eval("NumeroMesa") + "|salon|" + Eval("Estado") %>'
                                        OnClick="SeleccionarMesa_Click">
                                        <div class="mesa-number"><%# Eval("NumeroMesa") %></div>
                                        <i class="bi bi-octagon-fill mesa-icon"></i>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="LnkEliminarMesa" runat="server"
                                        CssClass="delete-btn"
                                        CommandArgument='<%# Eval("MesaId") + "|" + Eval("NumeroMesa") + "|salon" %>'
                                        OnClick="AbrirModalEliminarMesa_Click"
                                        OnClientClick="event.stopPropagation();">
                                        <i class="bi bi-x"></i>
                                    </asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:LinkButton ID="LnkAgregarSalon" runat="server" CssClass="add-mesa-card" CommandArgument="salon" OnClick="AgregarMesa_Click">
                            <i class="bi bi-plus-lg"></i>
                            <div style="color: #666; font-size: 14px;">Agregar Mesa</div>
                        </asp:LinkButton>
                    </div>
                </div>

                <!-- Patio Tab -->
                <div class="tab-pane fade <%= HdnTabActivo.Value == "patio" ? "show active" : "" %>" id="patio" role="tabpanel">
                    <div class="section-header">
                        <div class="section-title">Mesas del Patio</div>
                    </div>
                    <div class="mesas-grid">
                        <asp:Repeater ID="RepMesasPatio" runat="server">
                            <ItemTemplate>
                                <div style="position: relative;">
                                    <asp:LinkButton ID="LnkMesa" runat="server"
                                        CssClass='<%# "mesa-card " + ((string)Eval("Estado")).ToLower() %>'
                                        CommandArgument='<%# Eval("MesaId") + "|" + Eval("NumeroMesa") + "|patio|" + Eval("Estado") %>'
                                        OnClick="SeleccionarMesa_Click">
                                        <div class="mesa-number"><%# Eval("NumeroMesa") %></div>
                                        <i class="bi bi-octagon-fill mesa-icon"></i>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="LnkEliminarMesa" runat="server"
                                        CssClass="delete-btn"
                                        CommandArgument='<%# Eval("MesaId") + "|" + Eval("NumeroMesa") + "|patio" %>'
                                        OnClick="AbrirModalEliminarMesa_Click"
                                        OnClientClick="event.stopPropagation();">
                                        <i class="bi bi-x"></i>
                                    </asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:LinkButton ID="LnkAgregarPatio" runat="server" CssClass="add-mesa-card" CommandArgument="patio" OnClick="AgregarMesa_Click">
                            <i class="bi bi-plus-lg"></i>
                            <div style="color: #666; font-size: 14px;">Agregar Mesa</div>
                        </asp:LinkButton>
                    </div>
                </div>

                <!-- Mostrador Tab -->
                <div class="tab-pane fade <%= HdnTabActivo.Value == "mostrador" ? "show active" : "" %>" id="mostrador" role="tabpanel">
                    <div class="section-header">
                        <div class="section-title">Mostrador</div>
                        <div class="action-buttons">
                            <asp:LinkButton ID="LnkAbrirMostrador" runat="server" CssClass="btn btn-success btn-lg px-5 shadow-sm" OnClick="AbrirMostrador_Click">
                                <i class="bi bi-shop"></i> Abrir Mostrador
                            </asp:LinkButton>
                        </div>
                    </div>
                    <div id="ordenes-mostrador-container">
                        <asp:Repeater ID="RepOrdenesMostrador" runat="server">
                            <ItemTemplate>
                                <asp:LinkButton ID="LnkOrden" runat="server"
                                    CssClass="orden-mostrador-card"
                                    CommandArgument='<%# Eval("PedidoId") + "|" + Eval("NumeroMesa") + "|" + Eval("Ubicacion") %>'
                                    OnClick="SeleccionarOrdenMostrador_Click">
                                    <div class="orden-mostrador-header">
                                        <div>
                                            <div class="orden-mostrador-id">Orden #<%# Eval("PedidoId") %></div>
                                            <div class="orden-mostrador-fecha"><%# ((DateTime)Eval("FechaPedido")).ToString("dd/MM/yyyy HH:mm") %></div>
                                        </div>
                                        <div style="text-align: right;">
                                            <div style="font-weight: 600; color: #666;"><%# Eval("Ubicacion").ToString().ToUpper() %></div>
                                            <%# (bool)Eval("MostrarMesa") ? "<div style='font-size: 14px; color: #999;'>Mesa: " + Eval("NumeroMesa") + "</div>" : "" %>
                                        </div>
                                    </div>
                                    <div class="orden-mostrador-productos">
                                        <%# GenerarDetallesOrden((int)Eval("PedidoId")) %>
                                    </div>
                                    <div class="orden-mostrador-total">Total: $<%# ((decimal)Eval("Total")).ToString("N0") %></div>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Abrir Mesa -->
    <div class="modal fade" id="modalAbrirMesa" tabindex="-1" aria-labelledby="modalAbrirMesaLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalAbrirMesaLabel">
                        <i class="bi bi-octagon-fill"></i> Abrir Mesa <asp:Literal ID="LitNumeroMesaModal" runat="server"></asp:Literal>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="<%= TxtCantidadPersonas.ClientID %>" class="form-label">
                            <i class="bi bi-people-fill"></i> Cantidad de Personas
                        </label>
                        <asp:TextBox ID="TxtCantidadPersonas" runat="server" CssClass="form-control" TextMode="Number" min="1" placeholder="Ingrese cantidad de personas" Text="1"></asp:TextBox>
                    </div>
                    <div class="mb-4">
                        <label for="<%= DdlCamarero.ClientID %>" class="form-label">
                            <i class="bi bi-person-badge"></i> Camarero Asignado
                        </label>
                        <asp:DropDownList ID="DdlCamarero" runat="server" CssClass="form-select">
                            <asp:ListItem Value="">Seleccione un camarero</asp:ListItem>
                            <asp:ListItem Value="1">Juan Perez</asp:ListItem>
                            <asp:ListItem Value="2">Maria Gonzalez</asp:ListItem>
                            <asp:ListItem Value="3">Carlos Rodriguez</asp:ListItem>
                            <asp:ListItem Value="4">Ana Martinez</asp:ListItem>
                            <asp:ListItem Value="5">Luis Fernandez</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <asp:Button ID="BtnConfirmarAbrirMesa" runat="server" CssClass="btn-abrir-mesa" Text="Abrir Mesa" OnClick="ConfirmarAbrirMesa_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Orden -->
    <div class="modal fade" id="modalOrden" tabindex="-1" aria-labelledby="modalOrdenLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalOrdenLabel">
                        <i class="bi bi-clipboard-check"></i> Tomar Orden - Mesa <span id="modal-orden-mesa-numero"></span>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="UpdatePanelProductos" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div class="mb-3">
                                <label class="form-label">
                                    Buscar Producto
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white">
                                        <i class="bi bi-search"></i>
                                    </span>
                                    <asp:TextBox ID="TxtBuscarProducto" runat="server"
                                        CssClass="form-control"
                                        placeholder="Buscar en todas las categorias..."
                                        onkeydown="return handleEnterBusqueda(event);"
                                        OnTextChanged="BuscarProducto_TextChanged">
                                    </asp:TextBox>
                                    <asp:LinkButton ID="BtnLimpiarBusqueda" runat="server"
                                        CssClass="btn btn-outline-secondary"
                                        OnClick="LimpiarBusqueda_Click"
                                        Style="display: none;">
                                        <i class="bi bi-x-circle-fill"></i>
                                    </asp:LinkButton>
                                </div>
                            </div>

                            <% if (!HayBusquedaActiva) { %>
                                <!-- Tabs de categorias dinámicos -->
                                <ul class="nav nav-pills categorias-tabs" id="categoriasTabs" role="tablist">
                                    <asp:Repeater ID="RepCategorias" runat="server">
                                        <ItemTemplate>
                                            <li class="nav-item" role="presentation">
                                                <button class="nav-link <%# Container.ItemIndex == 0 ? "active" : "" %>"
                                                        id='categoria-<%# Eval("CategoriaId") %>-tab'
                                                        data-bs-toggle="pill"
                                                        data-bs-target='#categoria-<%# Eval("CategoriaId") %>'
                                                        type="button"
                                                        role="tab">
                                                    <i class="bi bi-tag-fill"></i> <%# Eval("Nombre") %>
                                                </button>
                                            </li>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </ul>

                                <!-- Contenido de tabs dinámico -->
                                <div class="tab-content" id="categoriasTabContent">
                                    <asp:Repeater ID="RepCategoriasContenido" runat="server" DataSource='<%# Categorias %>'>
                                        <ItemTemplate>
                                            <div class='tab-pane fade <%# Container.ItemIndex == 0 ? "show active" : "" %>'
                                                 id='categoria-<%# Eval("CategoriaId") %>'
                                                 role="tabpanel">
                                                <div class="productos-lista">
                                                    <%# GenerarProductosCategoria((int)Eval("CategoriaId")) %>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            <% } else { %>
                                <!-- Resultados de búsqueda -->
                                <div id="resultadosBusqueda">
                                    <h6 style="color: #666; margin-bottom: 15px;">
                                        <i class="bi bi-search"></i> Resultados de busqueda para "<%= TxtBuscarProducto.Text %>"
                                    </h6>
                                    <div class="productos-lista">
                                        <%= GenerarProductosBusqueda() %>
                                    </div>
                                </div>
                            <% } %>
                        </ContentTemplate>
                    </asp:UpdatePanel>

                    <div class="orden-resumen">
                        <h6 style="color: #333; font-weight: bold; margin-bottom: 15px;">
                            <i class="bi bi-receipt"></i> Resumen de la Orden
                        </h6>
                        <div id="resumenOrden" class="mb-2">
                            <p style="color: #999; font-style: italic;">No hay productos seleccionados</p>
                        </div>
                        <div class="orden-total">
                            <span>Total:</span>
                            <span id="totalOrden">$0</span>
                        </div>
                    </div>

                    <button type="button" class="btn btn-success mt-3 w-100 py-3" style="font-weight: 600; font-size: 16px;" onclick="confirmarOrden()">
                        <i class="bi bi-check-circle-fill"></i> Confirmar Orden
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Resumen y Pago -->
    <div class="modal fade" id="modalResumenPago" tabindex="-1" aria-labelledby="modalResumenPagoLabel" aria-hidden="true" data-bs-backdrop="static">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalResumenPagoLabel">
                        <i class="bi bi-receipt-cutoff"></i> Orden #<span id="modal-numero-orden"></span> - Mesa <span id="modal-resumen-mesa-numero"></span>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- Información de la orden -->
                    <div class="orden-info mb-3" style="background: #F6EFE0; padding: 15px; border-radius: 8px;">
                        <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                            <span style="color: #666;">Fecha:</span>
                            <span id="modal-fecha-orden" style="font-weight: 600;"></span>
                        </div>
                        <div style="display: flex; justify-content: space-between;">
                            <span style="color: #666;">Mesa:</span>
                            <span id="modal-ubicacion-mesa" style="font-weight: 600;"></span>
                        </div>
                    </div>

                    <!-- Lista de productos -->
                    <h6 style="color: #333; font-weight: bold; margin-bottom: 15px;">
                        <i class="bi bi-cart-check"></i> Productos
                    </h6>
                    <div class="resumen-completo" id="resumenCompleto" style="max-height: 300px; overflow-y: auto;">
                        <!-- Se llenara con JavaScript -->
                    </div>

                    <div class="orden-resumen mt-4">
                        <div class="orden-total">
                            <span>Total a Pagar:</span>
                            <span id="totalPagar" style="color: #28a745;">$0</span>
                        </div>
                    </div>

                    <div class="d-flex flex-column gap-3 mt-4">
                        <button type="button" class="btn btn-warning w-100 py-3" style="font-weight: 600; font-size: 16px;" onclick="agregarMasProductos()">
                            <i class="bi bi-plus-circle"></i> Agregar Mas Productos
                        </button>
                        <div class="d-flex gap-3">
                            <button type="button" class="btn btn-danger flex-fill py-3" style="font-weight: 600; font-size: 16px;"
                                onclick="if (confirm('¿Estás seguro de que deseas cancelar esta orden? Se perderán todos los productos.')) { <%= Page.ClientScript.GetPostBackEventReference(BtnCancelarOrdenHidden, "") %>; }">
                                <i class="bi bi-trash"></i> Cancelar Orden
                            </button>
                            <button type="button" class="btn btn-success flex-fill py-3" style="font-weight: 600; font-size: 16px;"
                                onclick="<%= Page.ClientScript.GetPostBackEventReference(BtnRealizarPagoHidden, "") %>">
                                <i class="bi bi-cash-coin"></i> Realizar Pago
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Confirmación Eliminar Mesa -->
    <div class="modal fade" id="modalEliminarMesa" tabindex="-1" aria-labelledby="modalEliminarMesaLabel" aria-hidden="true" data-bs-backdrop="static">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="modalEliminarMesaLabel">
                        <i class="bi bi-exclamation-triangle-fill"></i> Confirmar Eliminacion
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center py-4">
                    <i class="bi bi-trash3-fill text-danger" style="font-size: 48px;"></i>
                    <p class="mt-3 mb-0" style="font-size: 16px;">¿Estas seguro de que deseas eliminar la mesa <strong><span id="modalEliminarNumero"></span></strong>?</p>
                    <p class="text-muted mt-2">Esta accion no se puede deshacer.</p>
                    <asp:HiddenField ID="HdnMesaIdEliminar" runat="server" />
                    <asp:HiddenField ID="HdnMesaNumeroEliminar" runat="server" />
                    <asp:HiddenField ID="HdnMesaUbicacionEliminar" runat="server" />
                    <asp:HiddenField ID="HdnProductosOrden" runat="server" />
                    <asp:HiddenField ID="HdnPedidoIdActual" runat="server" />
                    <asp:Button ID="BtnConfirmarOrdenHidden" runat="server" Style="display:none;" OnClick="ConfirmarOrden_Click" />
                    <asp:Button ID="BtnRealizarPagoHidden" runat="server" Style="display:none;" OnClick="RealizarPago_Click" />
                    <asp:Button ID="BtnCancelarOrdenHidden" runat="server" Style="display:none;" OnClick="CancelarOrden_Click" />
                </div>
                <div class="modal-footer justify-content-center">
                    <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">
                        <i class="bi bi-x-circle"></i> Cancelar
                    </button>
                    <asp:Button ID="BtnConfirmarEliminar" runat="server" CssClass="btn btn-danger px-4" Text="Eliminar" OnClick="ConfirmarEliminarMesa_Click" />
                </div>
            </div>
        </div>
    </div>

    <script>
        // Función helper para formatear números
        const formatearPrecio = (num) => '$' + Math.round(num).toLocaleString('es-AR');

        // ===== MANEJO DE PRODUCTOS =====
        function cambiarCantidad(boton, incremento, event) {
            event.preventDefault();
            event.stopPropagation();
            const input = boton.closest('.producto-item').querySelector('input[type="number"]');
            input.value = Math.max(0, (parseInt(input.value) || 0) + incremento);
            actualizarResumenOrden();
        }

        function actualizarResumenOrden() {
            const resumenDiv = document.getElementById('resumenOrden');
            const totalSpan = document.getElementById('totalOrden');
            const tieneExistentes = resumenDiv?.getAttribute('data-tiene-existentes') === 'true';
            const productosExistentes = window.productosExistentesOrden || [];

            // Recolectar productos nuevos
            const productosNuevos = Array.from(document.querySelectorAll('.producto-item'))
                .map(p => {
                    const cantidad = parseInt(p.querySelector('input[type="number"]').value) || 0;
                    return cantidad > 0 ? {
                        nombre: p.getAttribute('data-nombre'),
                        precio: parseFloat(p.getAttribute('data-precio')),
                        cantidad: cantidad,
                        subtotal: parseFloat(p.getAttribute('data-precio')) * cantidad
                    } : null;
                })
                .filter(p => p !== null);

            // Construir HTML
            let html = '';
            let total = 0;

            const generarItemHTML = (prod, tipo) => {
                total += prod.subtotal;
                return `<div class="resumen-item" data-tipo="${tipo}">
                    <div class="resumen-item-info">
                        <div class="resumen-item-nombre">${prod.nombre}</div>
                        <div class="resumen-item-cantidad">Cantidad: ${prod.cantidad} x ${formatearPrecio(prod.precio)}</div>
                    </div>
                    <div class="resumen-item-precio">${formatearPrecio(prod.subtotal)}</div>
                </div>`;
            };

            if (tieneExistentes) html += productosExistentes.map(p => generarItemHTML(p, 'existente')).join('');
            html += productosNuevos.map(p => generarItemHTML(p, 'nuevo')).join('');

            resumenDiv.innerHTML = html || '<p style="color: #999; font-style: italic;">No hay productos seleccionados</p>';
            totalSpan.textContent = html ? formatearPrecio(total) : '$0';
        }

        function confirmarOrden() {
            const productos = Array.from(document.querySelectorAll('.producto-item'))
                .map(p => {
                    const cantidad = parseInt(p.querySelector('input[type="number"]').value) || 0;
                    return cantidad > 0 ? {
                        ProductoId: parseInt(p.getAttribute('data-productoid')),
                        Cantidad: cantidad,
                        PrecioUnitario: parseFloat(p.getAttribute('data-precio')),
                        Nombre: p.getAttribute('data-nombre')
                    } : null;
                })
                .filter(p => p !== null);c

            if (productos.length === 0) {
                alert('Por favor selecciona al menos un producto');
                return;
            }

            document.getElementById('<%= HdnProductosOrden.ClientID %>').value = JSON.stringify(productos);
            <%= Page.ClientScript.GetPostBackEventReference(BtnConfirmarOrdenHidden, "") %>;
        }

        // ===== MANEJO DE MODALS =====
        function agregarMasProductos() {
            bootstrap.Modal.getInstance(document.getElementById('modalResumenPago'))?.hide();
            setTimeout(() => {
                document.getElementById('modal-orden-mesa-numero').textContent =
                    document.getElementById('modal-resumen-mesa-numero').textContent;
                new bootstrap.Modal(document.getElementById('modalOrden')).show();
            }, 300);
        }

        // ===== BÚSQUEDA =====
        function handleEnterBusqueda(event) {
            if (event.keyCode === 13) {
                event.preventDefault();
                __doPostBack('<%= TxtBuscarProducto.UniqueID %>', '');
                return false;
            }
            return true;
        }

        function mantenerFocoEnBusqueda() {
            const prm = Sys?.WebForms?.PageRequestManager?.getInstance();
            if (prm) {
                prm.add_endRequest(() => {
                    const txtBuscar = document.getElementById('<%= TxtBuscarProducto.ClientID %>');
                    if (txtBuscar) {
                        setTimeout(() => {
                            txtBuscar.focus();
                            txtBuscar.setSelectionRange?.(txtBuscar.value.length, txtBuscar.value.length);
                        }, 100);
                    }
                });
            }
        }

        function limpiarBusquedaAlCerrarModal() {
            const txtBuscar = document.getElementById('<%= TxtBuscarProducto.ClientID %>');
            const btnLimpiar = document.getElementById('<%= BtnLimpiarBusqueda.ClientID %>');
            if (txtBuscar?.value.trim() && btnLimpiar?.style.display !== 'none') {
                btnLimpiar.click();
            }
        }

        // ===== INICIALIZACIÓN =====
        document.addEventListener('DOMContentLoaded', () => {
            mantenerFocoEnBusqueda();

            // Event listeners de modales
            document.getElementById('modalOrden')?.addEventListener('hidden.bs.modal', limpiarBusquedaAlCerrarModal);
        });
    </script>
</asp:Content>
