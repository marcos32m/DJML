﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace AerolineaFrba.Abm_Ciudad
{
    public partial class FormCiudades_Modi : Form
    {
        public FormCiudades_Modi()
        {
            InitializeComponent();
        }

        private void volver_Click(object sender, EventArgs e)
        {
            FormCiudades a = new FormCiudades();
            this.Hide();
            a.ShowDialog();
            a = (FormCiudades)this.ActiveMdiChild;
        }

        private void label_Click(object sender, EventArgs e)
        {

        }

        private void darBaja_Click(object sender, EventArgs e)
        {

        }

        private void FormCiudades_Modi_Load(object sender, EventArgs e)
        {

        }
    }
}
