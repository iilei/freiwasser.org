let’s architect a Europe-first MVP, with a built-in path to add more regions later (for paid users) without refactoring the entire stack.

🗺️ MVP ARCHITECTURE: EUROPE ONLY (modular for future regions)
Goal

✔️ Start with Europe only → cheapest dataset, fastest import
✔️ One PostGIS database
✔️ Tegola serves tiles by region
✔️ Later: attach additional region datasets without breaking anything
✔️ Region logic implemented via Go API only → NOT in DB or Tegola

📦 FILE STRUCTURE (Recommended)
osm-stack/
 ├─ data/
 │   ├─ europe.osm.pbf       ← first region
 │   ├─ regions.json         ← metadata of served regions
 │   └─ extra/               ← future paid regions
 │
 ├─ tegola-configs/
 │   ├─ europe.toml
 │   └─ world.toml           ← future, optional
 │
 ├─ api/
 │   └─ go-server/
 │
 ├─ auth/                    ← authentik / JWT claims
 │
 ├─ docker-compose.yml
 └─ README.md

🧠 Key Design Idea: Regions Are Metadata — Not Separate Databases

Create regions.json:

[
  {
    "id": "eu",
    "name": "Europe",
    "file": "data/europe.osm.pbf",
    "bbox": [ -11.0, 34.5, 31.5, 71.5 ]
  }
]


In Go API:

type Region struct {
    ID   string   `json:"id"`
    Name string   `json:"name"`
    BBox []float64 `json:"bbox"`
}

var regions []Region // load from regions.json on startup


Later, when upgrading to “paid regions”, just append to JSON:

{
  "id": "asia",
  "name": "Asia",
  "file": "data/asia.osm.pbf",
  "bbox": [ 24.0, -1.0, 154.0, 55.0 ],
  "paid": true
}

🚀 DATABASE DESIGN (SIMPLE & FUTURE SAFE)
One database — but use region column:
ALTER TABLE planet_osm_point ADD COLUMN region text;
UPDATE planet_osm_point SET region = 'eu';


Later:

UPDATE planet_osm_point SET region = 'asia' WHERE ST_Within(way, ST_GeomFromText('POLYGON(...)'));


Query filter:

SELECT * FROM planet_osm_point WHERE region = $1;


➡️ No schema migration required
➡️ One DB, low-maintenance
➡️ Easy region-based billing

🧩 TEGOLA CONFIG
[[maps]]
name = "europe"
layer = [
    { name = "roads",    region = "eu" },
    { name = "buildings", region = "eu" }
]


Later (paid regions):

[[maps]]
name = "asia"
layer = [
    { name = "roads",    region = "asia" },
    { name = "buildings", region = "asia" }
]

🔐 AUTHENTICATION & REGION ACCESS
Proposed rules:
Region	Access
Europe	Free / no auth
Other regions	Need token / paid flag
Admin	All regions

JWT claim example (authentik):

{
  "user": "abc",
  "paid_regions": ["asia", "usa"]
}


Go middleware:

func CanAccessRegion(region string, claims Claims) bool {
    if region == "eu" { return true }
    for _, r := range claims.PaidRegions {
        if r == region { return true }
    }
    return false
}

💾 TERRAFORM – RESOURCE LAYOUT
module "osm" {
  source = "./modules/osm-core"  # always active
}

module "auth" {
  source = "./modules/authentik" # optional
}

module "storage" {
  source = "./modules/regions"   # future add-ons
  regions_enabled = ["asia", "usa"] # toggle per env
}


➡️ Paid regions activated just by adding a string to a TF list.

🧭 MVP → SCALE-UP ROADMAP
Phase 1 – Europe only (MVP)

DB with region = 'eu'

Go API → no billing logic yet

Tegola → only EU tiles

Phase 2 – Prep for paid regions

Add JWT middleware

Add region filtering in SQL queries

Add tier list in Go

Phase 3 – Sell paid regions

Download new .osm.pbf

Import in background

Add to regions.json

Update Terraform list

DONE → no breaking changes 🎉

🎯 TL;DR

Make regions “metadata,” not infrastructure.
Regions.json + region column in DB + header-based access control =
scalable + cheap + easy to maintain.
