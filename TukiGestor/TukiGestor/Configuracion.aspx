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

        .options-container{

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
    </style>

    <div class="config-container">
        <div class="config-box">
            <h2 class="config-title"><i class="bi bi-gear"></i>Configuración</h2>

            <div class="options-container">
            <!-- Modo claro / oscuro -->
            <div class="config-option">
                <div class="config-label">
                    <i class="bi bi-moon"></i>Modo oscuro
                </div>
                <label class="switch">
                    <input type="checkbox" id="modoOscuro">
                    <span class="slider"></span>
                </label>
            </div>
            <!-- Idioma -->
            <div class="config-option">
                <div class="config-label">
                    <i class="bi bi-translate"></i>Idioma
                </div>
                <select id="idiomaSelect" class="config-select">
                    <option value="es">Español</option>
                    <option value="en">Inglés</option>
                </select>
            </div>

            <!-- IVA -->
            <div class="config-option">
                <div class="config-label">
                    <i class="bi bi-percent"></i>IVA
                </div>
                <input type="number" id="ivaInput" class="config-input" value="21" min="0" max="50">
                %
            </div>
                </div>

        </div>
    </div>
</asp:Content>
