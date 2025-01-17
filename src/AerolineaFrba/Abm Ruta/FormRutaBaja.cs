﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;
using AerolineaFrba.Properties;

namespace AerolineaFrba.Abm_Ruta
{
    public partial class FormRutaBaja : Form
    {        
        public FormRutaBaja()
        {
            InitializeComponent();
        }

        private void FormRutaBaja_Load(object sender, EventArgs e)
        {
            LlenarCombo_Origen();
            comboBox_origen.DropDownStyle = ComboBoxStyle.DropDownList;
            LlenarCombo_Destino();
            comboBox_destino.DropDownStyle = ComboBoxStyle.DropDownList;
            LlenarCombo_Servicio();
            comboBox_servicio.DropDownStyle = ComboBoxStyle.DropDownList;
        }

        public void LlenarCombo_Origen()
        {
            SqlConnection conexion = new SqlConnection();
            conexion.ConnectionString = Settings.Default.CadenaDeConexion;

            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter("SELECT CIUD_DETALLE FROM DJML.CIUDADES ORDER BY 1", conexion);
            da.Fill(ds, "DJML.CIUDADES");

            comboBox_origen.DataSource = ds.Tables[0].DefaultView;
            comboBox_origen.ValueMember = "CIUD_DETALLE";
            comboBox_origen.SelectedItem = null;
        }

        public void LlenarCombo_Destino()
        {
            SqlConnection conexion = new SqlConnection();
            conexion.ConnectionString = Settings.Default.CadenaDeConexion;

            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter("SELECT CIUD_DETALLE FROM DJML.CIUDADES ORDER BY 1", conexion);
            da.Fill(ds, "DJML.CIUDADES");

            comboBox_destino.DataSource = ds.Tables[0].DefaultView;
            comboBox_destino.ValueMember = "CIUD_DETALLE";
            comboBox_destino.SelectedItem = null;
        }


        public void LlenarCombo_Servicio()
        {
            SqlConnection conexion = new SqlConnection();
            conexion.ConnectionString = Settings.Default.CadenaDeConexion;

            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter("SELECT SERV_DESCRIPCION FROM DJML.SERVICIOS ORDER BY 1", conexion);
            da.Fill(ds, "DJML.SERVICIOS");

            comboBox_servicio.DataSource = ds.Tables[0].DefaultView;
            comboBox_servicio.ValueMember = "SERV_DESCRIPCION";
            comboBox_servicio.SelectedItem = null;
        }



        private void dataGrid_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            string RutaCodigo = dataGrid.Rows[e.RowIndex].Cells[1].Value.ToString();

            darBajaRuta(RutaCodigo);
        }

        private void darBajaRuta(string codigo)
        {   
            string qry = "SELECT 1 FROM DJML.VIAJES" +
                        " JOIN DJML.RUTAS ON VIAJE_RUTA_ID = RUTA_CODIGO" +
                        " WHERE RUTA_CODIGO = " + codigo +
                        " AND GETDATE() BETWEEN VIAJE_FECHA_SALIDA AND VIAJE_FECHA_LLEGADA_ESTIMADA";

            var result = new Query(qry).ObtenerDataTable();
            if (result.Rows.Count != 0)
            {
                MessageBox.Show("Esta ruta esta en uso, no se puede dar de baja", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            else
            {
                cancelar_pasajes_y_encomiendas(codigo);
                string qry_update = "update DJML.RUTAS" +
                          " set RUTA_IS_ACTIVE = 0 " +
                          " where RUTA_CODIGO = " + codigo;
                new Query(qry_update).Ejecutar();

                MessageBox.Show("Se ha dado de baja la ruta de codigo " + codigo + " correctamente", "", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
        }

        private void button_buscar_Click(object sender, EventArgs e)
        {

            string origen = comboBox_origen.Text;
            string destino = comboBox_destino.Text;
            string servicio = comboBox_servicio.Text;

            string qry = "select RUTA_CODIGO ruta_codigo, co.CIUD_DETALLE origen, cd.CIUD_DETALLE destino, s.SERV_DESCRIPCION servicio, r.RUTA_PRECIO_BASE_KILO precio_base_kilo, r.RUTA_PRECIO_BASE_PASAJE precio_base_pasaje" +
                        " from djml.RUTAS r" +
                        " join djml.TRAMOS t on r.RUTA_TRAMO = t.TRAMO_ID" +
                        " join djml.CIUDADES co on co.CIUD_ID = t.TRAMO_CIUDAD_ORIGEN" +
                        " join djml.CIUDADES cd on cd.CIUD_ID = t.TRAMO_CIUDAD_DESTINO" +
                        " join djml.SERVICIOS s on r.RUTA_SERVICIO = s.SERV_ID" +
                        " where co.CIUD_DETALLE like '%" + origen + "'" +
                        " and cd.CIUD_DETALLE like '%" + destino + "'" +
                        " and s.SERV_DESCRIPCION like '%" + servicio + "'" +
                        " and r.RUTA_IS_ACTIVE = 1";

            var result = new Query(qry).ObtenerDataTable();
            if (result.Rows.Count != 0 && origen != string.Empty &&  destino != string.Empty && servicio != string.Empty)
            {
                dataGrid.DataSource = result;
            }
            else
            {
                MessageBox.Show("Ninguna ruta coincide con su descripción.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }       
        }

        private void button_volver_Click(object sender, EventArgs e)
        {
            FormRuta volver = new FormRuta();
            volver.StartPosition = FormStartPosition.CenterScreen;
            this.Hide();
            volver.ShowDialog();
            volver = (FormRuta)this.ActiveMdiChild;
        }

        public void cancelar_pasajes_y_encomiendas(string codigo) {           
            
            //INSERT DE LA NUEVA CANCELACION
            string insertCancelaciones = " INSERT INTO [DJML].[CANCELACIONES] ([CANC_FECHA_DEVOLUCION] , [CANC_COMPRA_ID] , [CANC_MOTIVO])" +
                                 " SELECT GETDATE(), COMPRA_ID, 'La ruta fue dada de baja'" +
                                 " FROM DJML.COMPRAS" +
                                 " JOIN DJML.VIAJES ON COMPRA_VIAJE_ID = VIAJE_ID" +
                                 " JOIN DJML.RUTAS ON VIAJE_RUTA_ID = RUTA_CODIGO" +
                                 " WHERE RUTA_CODIGO = " + codigo +
                                 " AND VIAJE_FECHA_SALIDA > GETDATE()";
            Query qryCancelaciones = new Query(insertCancelaciones);
            qryCancelaciones.pComando = insertCancelaciones;
            qryCancelaciones.Ejecutar();

            string stringCancelaciones = " SELECT CANC_ID, CANC_COMPRA_ID" +
                                 " FROM DJML.CANCELACIONES" +
                                 " JOIN DJML.COMPRAS ON COMPRA_ID = CANC_COMPRA_ID" +
                                 " JOIN DJML.VIAJES ON COMPRA_VIAJE_ID = VIAJE_ID" +
                                 " JOIN DJML.RUTAS ON VIAJE_RUTA_ID = RUTA_CODIGO" +
                                 " WHERE RUTA_CODIGO = " + codigo;
            var cancelaciones = new Query(stringCancelaciones).ObtenerDataTable();

            for (int i = 0; i <= cancelaciones.Rows.Count - 1; i++)
            {
                // LE AGREGO EL CODIGO DE DEVOLUCION A LOS PASAJES
                string pasajes = " UPDATE [DJML].[PASAJES] SET [CANCELACION_ID] = " + cancelaciones.Rows[i][0].ToString() +
                                 " WHERE PASA_COMPRA_ID = " + cancelaciones.Rows[i][1].ToString();
                Query qryPasajes = new Query(pasajes);
                qryPasajes.Ejecutar();

                // LE AGREGO EL CODIGO DE DEVOLUCION A LAS ENCOMIENDAS
                string encomiendas = " UPDATE [DJML].[ENCOMIENDAS] SET [CANCELACION_ID] = " + cancelaciones.Rows[i][0].ToString() +
                                     " WHERE PASA_COMPRA_ID = " + cancelaciones.Rows[i][1].ToString();
                Query qryEncomiendas = new Query(encomiendas);
                qryEncomiendas.Ejecutar();
            }            

            //MODIFICO EL PRECIO DE COMPRA (LE RESTO EL PRECIO DE LOS PASAJES Y ENCOMIENDAS CANCELADAS)
            string precios = " UPDATE [DJML].[COMPRAS] SET [COMPRA_MONTO] = 0" +
                             " WHERE COMPRA_ID IN (SELECT CANC_COMPRA_ID" +
                                 " FROM DJML.CANCELACIONES" +
                                 " JOIN DJML.COMPRAS ON COMPRA_ID = CANC_COMPRA_ID" +
                                 " JOIN DJML.VIAJES ON COMPRA_VIAJE_ID = VIAJE_ID" +
                                 " JOIN DJML.RUTAS ON VIAJE_RUTA_ID = RUTA_CODIGO" +
                                 " WHERE RUTA_CODIGO = " + codigo + ")";
            Query qryPrecios = new Query(precios);
            qryPrecios.Ejecutar();

            //LIBERO BUTACAS DE LOS PASAJES CANCELADOS
            string qryButacas = " UPDATE DJML.BUTACA_AERO SET BXA_ESTADO = 1" +
                         " WHERE BXA_BUTA_ID IN (SELECT PASA_BUTA_ID " +
                                                " FROM DJML.PASAJES" +
                                                " WHERE PASA_COMPRA_ID IN (SELECT COMPRA_ID" +
                                                                         " FROM DJML.COMPRAS" +
						                                                 " JOIN DJML.VIAJES ON COMPRA_VIAJE_ID = VIAJE_ID" +
						                                                 " JOIN DJML.RUTAS ON VIAJE_RUTA_ID = RUTA_CODIGO" +
						                                                 " WHERE RUTA_CODIGO = " + codigo +
						                                                 " AND VIAJE_FECHA_SALIDA > GETDATE()))";
            new Query(qryButacas).Ejecutar();

            //LIBERO KILOS DE LA AERONAVE DE LAS ENCOMIENDAS CANCELADAS
            string stringAeronaves = "SELECT VIAJE_AERO_ID, MAX(SUMA) " +
                                    " FROM ("+
	                                        " SELECT VIAJE_AERO_ID, SUM(ENCO_KG) SUMA " +
	                                        " FROM DJML.ENCOMIENDAS " +
	                                        " JOIN DJML.VIAJES ON ENCO_VIAJE_ID = VIAJE_ID " +
	                                        " JOIN DJML.RUTAS ON VIAJE_RUTA_ID = RUTA_CODIGO " +
                                            " WHERE RUTA_CODIGO = " + codigo + " AND VIAJE_FECHA_SALIDA > GETDATE()" +
	                                        " GROUP BY ENCO_VIAJE_ID, VIAJE_AERO_ID " +
                                    " ) aux " +
                                    " GROUP BY VIAJE_AERO_ID ";
            var aeronaves = new Query(stringAeronaves).ObtenerDataTable();

            for (int i = 0; i <= aeronaves.Rows.Count - 1; i++)
            {
                // ACTUALIZO KILOS DISPONIBLES
                string kilos = " UPDATE [GD2C2015].[DJML].[AERONAVES] SET [AERO_KILOS_DISPONIBLES] = AERO_KILOS_DISPONIBLES + " + aeronaves.Rows[i][1].ToString() +
                                 " WHERE AERO_MATRICULA = '" + aeronaves.Rows[i][0].ToString() + "'";
                Query qryKilos = new Query(kilos);
                qryKilos.Ejecutar();
            }         
        }
      
    }
}
