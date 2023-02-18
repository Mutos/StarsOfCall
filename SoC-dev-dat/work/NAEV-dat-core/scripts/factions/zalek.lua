return {
   fct            = faction.get("Za'lek"),
   cap_kill       = 15,
   delta_distress = {-0.5, 0},  -- Maximum change constraints
   delta_kill     = {-5, 1},    -- Maximum change constraints
   cap_misn_def   = 30,
   cap_misn_var   = "_fcap_zalek",
   cap_tags       = {
      ["zlk_cap_ch01_sml"] = { val=1, max=50 },
      ["zlk_cap_ch01_med"] = { val=3, max=50 },
      ["zlk_cap_ch01_lrg"] = { val=5, max=50 },
      ["zlk_cap_ch2z_sml"] = { val=1, max=70 },
      ["zlk_cap_ch2z_med"] = { val=3, max=70 },
      ["zlk_cap_ch2z_lrg"] = { val=5, max=70 },
   },
   -- Based on academic hierarchy
   text = {
      [100] = _("Professor Emeritus"),
      [90]  = _("Professor"),
      [80]  = _("Associate Professor"),
      [70]  = _("Assistant Professor"),
      [50]  = _("Senior Fellow"),
      [30]  = _("Fellow"),
      [10]  = _("Independent Researcher"),
      [0]   = _("Learner"),
      [-1]  = _("Scorned"),
      [-30] = _("Outlaw"),
      [-50] = _("Enemy"),
   },
   text_friendly  = _("Benevolent"),
   text_neutral   = _("Impartial"),
   text_hostile   = _("Belligerent"),
   text_bribed    = _("Funded"),
}
