using System;
using System.Collections.Generic;

namespace efzLagerEFDbFirst.Models
{
    public partial class Verkaufsprei
    {
        public int ArtikelId { get; set; }
        public int WaehrungsId { get; set; }
        public decimal Verkaufspreis { get; set; }

        public virtual Artikel Artikel { get; set; } = null!;
        public virtual Waehrung Waehrungs { get; set; } = null!;
    }
}
