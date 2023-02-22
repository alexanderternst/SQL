using System;
using System.Collections.Generic;

namespace efzLagerEFDbFirst.Models
{
    public partial class Einkauf
    {
        public int ArtikelId { get; set; }
        public int LieferantId { get; set; }
        public int WaehrungsId { get; set; }
        public decimal Einkaufspreis { get; set; }

        public virtual Artikel Artikel { get; set; } = null!;
        public virtual Lieferant Lieferant { get; set; } = null!;
        public virtual Waehrung Waehrungs { get; set; } = null!;
    }
}
