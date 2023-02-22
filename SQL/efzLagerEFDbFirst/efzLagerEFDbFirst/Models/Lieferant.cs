using System;
using System.Collections.Generic;

namespace efzLagerEFDbFirst.Models
{
    public partial class Lieferant
    {
        public Lieferant()
        {
            Einkaufs = new HashSet<Einkauf>();
        }

        public int LieferantId { get; set; }
        public string Lieferant1 { get; set; } = null!;

        public virtual ICollection<Einkauf> Einkaufs { get; set; }
    }
}
