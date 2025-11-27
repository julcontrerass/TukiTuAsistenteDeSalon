<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Configuracion.aspx.cs" Inherits="TukiGestor.WebForm2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">


    <style>
        .config-container {
            position: fixed;
            left: calc(50vw + 140px);
            transform: translateX(-50%);
            top: 40px;
            z-index: 100;
            min-width: 80%;
            max-width: 1000px;
            padding: 20px;
            padding-bottom: 120px;
            min-height: 80vh;
        }

        .config-box {
            background: #F6EFE0;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }

        .config-title {
            color: #333;
            font-weight: bold;
            margin-bottom: 30px;
        }

        .options-container {
            padding-top: 2rem;
        }

        .config-option {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #E7D9C2;
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
            max-width: 300px;
        }

            .config-option:hover {
                background-color: #d9cbb0;
            }

        .config-label {
            font-weight: 600;
            color: #333;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .config-option i {
            font-size: 1.3rem;
            color: #333;
        }

        .config-select, .config-input {
            border: none;
            border-radius: 8px;
            background-color: #fff;
            color: #333;
            padding: 8px 12px;
            font-weight: 500;
            min-width: 150px;
        }

            .config-select:focus, .config-input:focus {
                outline: 2px solid #b5a58a;
            }

        .switch {
            position: relative;
            display: inline-block;
            width: 50px;
            height: 26px;
        }

            .switch input {
                opacity: 0;
                width: 0;
                height: 0;
            }

        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            border-radius: 34px;
            transition: 0.4s;
        }

            .slider:before {
                position: absolute;
                content: "";
                height: 18px;
                width: 18px;
                left: 4px;
                bottom: 4px;
                background-color: white;
                border-radius: 50%;
                transition: 0.4s;
            }

        input:checked + .slider {
            background-color: #646464;
        }

            input:checked + .slider:before {
                transform: translateX(24px);
            }


        .alert-custom {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            text-align: center;
            font-weight: 500;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .alert-warning {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }
    </style>

    <div class="config-container">
        <div class="config-box">
            <h2 class="mb-4" style="color: #333; font-weight: bold;">
                <i class="bi bi-person-circle"></i>
                Perfil de usuario
            </h2>


            <div class="p-4">
                <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="alert-custom">

                    <asp:Label ID="lblMensaje" runat="server"></asp:Label>
                </asp:Panel>

                <h4 class="mb-3">Editar</h4>
                <asp:HiddenField ID="hfProductoId" runat="server" />
                <div class="mb-3">
                    <label for="lnbNombreUsuario" class="form-label">Nombre de Usuario</label>
                    <asp:TextBox ID="txtNombreUsuario" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label for="lnlNombre" class="form-label">Nombre</label>
                    <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label for="lnbApellido" class="form-label">Apellido</label>
                    <asp:TextBox ID="txtApellido" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label for="lblEmail" class="form-label">Email</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label for="lblContraseña" class="form-label">Contraseña</label>
                    <asp:TextBox ID="txtContraseña" TextMode="Password" runat="server" CssClass="form-control"></asp:TextBox>
                    <small class="text-muted">Si no desea cambiar la contraseña, deje este campo vacío.</small>
                </div>
                <div class="d-flex gap-2">
                    <asp:Button ID="Button1" runat="server" Text="Actualizar" CssClass="btn btn-custom mt-3" OnClick="btnActualizarMesero_Click" />
                    <asp:Button ID="btnCancelarEditar" runat="server" Text="Cancelar" CssClass="btn btn-secondary mt-3" OnClick="btnCancelarActualizarMesero_Click" />
                </div>
            </div>

        </div>
    </div>
</asp:Content>
