using System;
using System.Collections.Generic;

namespace efzLagerEFDbFirst.Models
{
    public partial class ArtikelLager
    {
        public int ArtikelId { get; set; }
        public int LagerortId { get; set; }
        public int LagerMenge { get; set; }

        public virtual Artikel Artikel { get; set; } = null!;
        public virtual Lagerort Lagerort { get; set; } = null!;
    }
}
