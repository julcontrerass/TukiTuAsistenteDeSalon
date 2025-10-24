﻿<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="TukiGestor.About" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .container.body-content {
            padding: 0 !important;
            margin: 0 !important;
            margin-bottom: 0 !important;
            max-width: 100% !important;
            width: 100% !important;
            height: calc(100vh - 80px);
            flex: 1 !important;
            overflow: visible !important;
        }

        .home-container {
            position: fixed;
            left: calc(50vw + 140px);
            top: calc(50vh - 40px);
            transform: translate(-50%, -50%);
            z-index: 100;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 20px;
        }

        .sidebar.collapsed ~ .main-wrapper .home-container {
            left: calc(50vw + 40px);
        }
        
        .welcome-section {
            background-color: #fff;
            border-radius: 15px;
            padding: 50px 40px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            max-width: 800px;
            width: 100%;
        }
        
        .welcome-section h2 {
            color: #666;
            font-size: 1.8em;
            margin-bottom: 15px;
            font-weight: 300;
        }
        
        .welcome-section p {
            color: #777;
            font-size: 1.2em;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .btn-primary-custom {
            background-color: #E7D8C1;
            color: #333;
            padding: 12px 30px;
            border: none;
            border-radius: 25px;
            font-size: 1.1em;
            cursor: pointer;
            transition: background-color 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-primary-custom:hover {
            background-color: #d4c5ae;
            color: #000;
            text-decoration: none;
        }
    </style>
    <div class="home-container">
        <div class="welcome-section">
            <h2>Bienvenido a tu asistente de salón</h2>
            <p>Gestiona tu negocio de manera eficiente con nuestras herramientas diseñadas especialmente para salones y restaurantes</p>
            <a href="Mesas.aspx" class="btn-primary-custom">Comenzar</a>
        </div>
    </div>
</asp:Content>