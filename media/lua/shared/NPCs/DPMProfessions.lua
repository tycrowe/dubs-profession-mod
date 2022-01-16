--
-- DPMProfesions.lua
-- User: Ty C. [Dubpub]
-- Date: 12/28/2021
--
-- Function credit: https://stackoverflow.com/questions/2282444/how-to-check-if-a-table-contains-an-element-in-lua
function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

DPMProfessions = {}

-- Stolen from MainCreationMethods, requiring doesn't seem to work here, so I'll just steal it :)
function DPMProfessions.SetProfessionDescription(prof)
    local desc = getTextOrNull("UI_profdesc_" .. prof:getType()) or ""
    local boost = transformIntoKahluaTable(prof:getXPBoostMap())
    local infoList = {}
    for perk, level in pairs(boost) do
        local perkName = PerkFactory.getPerkName(perk)
        -- "+1 Cooking" etc
        local levelStr = tostring(level:intValue())
        if level:intValue() > 0 then
            levelStr = "+" .. levelStr
        end
        table.insert(infoList, { perkName = perkName, levelStr = levelStr })
    end
    table.sort(infoList, function(a, b)
        return not string.sort(a.perkName, b.perkName)
    end)
    for _, info in ipairs(infoList) do
        if desc ~= "" then
            desc = desc .. "\n"
        end
        desc = desc .. info.levelStr .. " " .. info.perkName
    end
    local traits = prof:getFreeTraits()
    for j = 1, traits:size() do
        if desc ~= "" then
            desc = desc .. "\n"
        end
        local traitName = traits:get(j - 1)
        local trait = TraitFactory.getTrait(traitName)
        desc = desc .. trait:getLabel()
    end
    prof:setDescription(desc)
end

DPMProfessions.DoTraits = function()
    for _, trait in pairs(DPMFreeTraitConfig) do
        local created_trait = TraitFactory.addTrait(trait['type'], trait['name'], trait['cost'], trait['desc'], trait['profession']);
        trait['boosts'](created_trait)
    end
    -- Add our custom traits. [Not in game!]
    -- TODO
end

DPMPerkMapping = {
    Cooking = Perks.Cooking,
    Fitness = Perks.Fitness,
    Strength = Perks.Strength,
    Blunt = Perks.Blunt,
    Axe = Perks.Axe,
    Sprinting = Perks.Sprinting,
    Lightfoot = Perks.Lightfoot,
    Nimble = Perks.Nimble,
    Sneak = Perks.Sneak,
    Woodwork = Perks.Woodwork,
    Aiming = Perks.Aiming,
    Reloading = Perks.Reloading,
    Farming = Perks.Farming,
    Survivalist = Perks.Survivalist,
    Fishing = Perks.Fishing,
    Trapping = Perks.Trapping,
    Firearm = Perks.Firearm,
    PlantScavenging = Perks.PlantScavenging,
    Doctor = Perks.Doctor,
    Electricity = Perks.Electricity,
    MetalWelding = Perks.MetalWelding,
    Mechanics = Perks.Mechanics,
    Spear = Perks.Spear,
    Maintenance = Perks.Maintenance,
    SmallBlade = Perks.SmallBlade,
    LongBlade = Perks.LongBlade,
    SmallBlunt = Perks.SmallBlunt,
    Tailoring = Perks.Tailoring
}

DPMFreeTraitConfig = {
    {
        type = "dpm_KeenHearing",
        name = getText("UI_trait_keenhearing"),
        cost = -2,
        desc = getText("UI_trait_keenhearingdesc"),
        profession = true,
        boosts = function(trait)

        end
    },
    {
        type = "dpm_Cowardly",
        name = getText("UI_trait_cowardly"),
        cost = 3,
        desc = getText("UI_trait_keenhearingdesc"),
        profession = true,
        boosts = function(trait)

        end
    },
    {
        type = "dpm_EagleEyed",
        name = getText("UI_trait_eagleeyed"),
        cost = -4,
        desc = getText("UI_trait_eagleeyeddesc"),
        profession = true,
        boosts = function(trait)

        end
    },
    {
        type = "dpm_Strong",
        name = getText("UI_trait_strong"),
        cost = -8,
        desc = getText("UI_trait_strongdesc"),
        profession = true,
        boosts = function(trait)

        end
    },
    {
        type = "dpm_Feeble",
        name = getText("UI_trait_feeble"),
        cost = 0,
        desc = getText("UI_trait_feebledesc"),
        profession = true,
        boosts = function(trait)

        end
    },
    {
        type = "dpm_Outdoorsman",
        name = getText("UI_trait_outdoorsman"),
        cost = -4,
        desc = getText("UI_trait_outdoorsmandesc"),
        profession = true,
        boosts = function(trait)

        end
    },
    {
        type = "dpm_FastReader",
        name = getText("UI_trait_FastReader"),
        cost = -4,
        desc = getText("UI_trait_FastReaderDesc"),
        profession = true,
        boosts = function(trait)

        end
    },
    {
        type = "dpm_Organized",
        name = getText("UI_trait_Packmule"),
        cost = -4,
        desc = getText("UI_trait_PackmuleDesc"),
        profession = true,
        boosts = function(trait)

        end
    },
    {
        type = "dpm_Pacifist",
        name = getText("UI_trait_Pacifist"),
        cost = 4,
        desc = getText("UI_trait_PacifistDesc"),
        profession = true,
        boosts = function(trait)

        end
    },
    {
        type = "dpm_Brave",
        name = getText("UI_trait_brave"),
        cost = -4,
        desc = getText("UI_trait_bravedesc"),
        profession = true,
        boosts = function(trait)

        end
    },
    {
        type = "dpm_natural_learner",
        name = "Further increased XP gains.",
        cost = -9,
        desc = "You gain experience slightly faster across the board.",
        profession = true,
        boosts = function(trait)end
    }
}

DPMProfessions.ApplyFreeTrait = function(prof, type, with_cost)
    local temp = TraitFactory.getTrait(type)
    if temp ~= nil then
        prof:addFreeTrait(type);
        if with_cost then
            prof:setCost(prof:getCost() + temp:getCost())
        end
    end
end

DPMProfessionsConfig = {
    {
        type = "dpm_teacher",
        name = "Teacher",
        icon = "dpm_teacher.png",
        cost = 0,
        desc = "",
        perks = {
            Doctor = 1
        },
        free_perks = function(prof)
            DPMProfessions.ApplyFreeTrait(prof, 'dpm_KeenHearing', false);
        end
    },
    {
        type = "dpm_professor",
        name = "Professor",
        icon = "dpm_professor.png",
        cost = 0,
        desc = "",
        perks = {},
        free_perks = function(prof)
            DPMProfessions.ApplyFreeTrait(prof, 'NightOwl', false);
            DPMProfessions.ApplyFreeTrait(prof, 'dpm_Organized', true);
        end
    },
    {
        type = "dpm_student",
        name = "Student",
        icon = "dpm_student.png",
        cost = 0,
        desc = "",
        perks = {
            Sprinting = 2
        },
        free_perks = function(prof)
            DPMProfessions.ApplyFreeTrait(prof, 'dpm_Feeble', true);
        end
    },
    {
        type = "dpm_librarian",
        name = "Librarian",
        icon = "dpm_librarian.png",
        cost = 0,
        desc = "",
        perks = {
            Lightfoot = 2
        },
        free_perks = function(prof)
            DPMProfessions.ApplyFreeTrait(prof, 'dpm_FastReader', false);
        end
    },
    {
        type = "dpm_paramedic",
        name = "Paramedic",
        icon = "dpm_paramedic.png",
        cost = 0,
        desc = "",
        perks = {
            Doctor = 2
        },
        free_perks = function(prof)
        end
    },
    {
        type = "dpm_lifeguard",
        name = "Lifeguard",
        icon = "dpm_lifeguard.png",
        cost = 0,
        desc = "",
        perks = {
            Fitness = 3,
            Sprinting = 2,
            Doctor = 1
        },
        free_perks = function(prof)
        end
    },
    {
        type = "dpm_garbageman",
        name = "Garbage Man",
        icon = "dpm_janitor.png",
        cost = 0,
        desc = "",
        perks = {
            Fitness = 2,
            Sprinting = 1
        },
        free_perks = function(prof)
        end
    },
    {
        type = "dpm_soldier",
        name = "Soldier",
        icon = "dpm_mercenary.png",
        cost = 0,
        desc = "",
        perks = {
            Fitness = 3,
            Strength = 2,
            Reloading = 2,
            Aiming = 3,
            Sprinting = 2,
            Doctor = 1
        },
        free_perks = function(prof)
        end
    },
    {
        type = "dpm_waiter",
        name = "Waiter",
        icon = "dpm_waiter.png",
        cost = 0,
        desc = "",
        perks = {
            Nimble = 2,
            Maintenance = 1
        },
        free_perks = function(prof)
        end
    },
    {
        type = "dpm_actor",
        name = "Actor",
        icon = "dpm_actor.png",
        cost = 0,
        desc = "",
        perks = {
            Nimble = 2,
            Lightfoot = 1,
            Fitness = 2
        },
        free_perks = function(prof)
        end
    },
    {
        type = "dpm_pilot",
        name = "Pilot",
        icon = "dpm_pilot.png",
        cost = 0,
        desc = "",
        perks = {},
        free_perks = function(prof)
            DPMProfessions.ApplyFreeTrait(prof, 'dpm_EagleEyed', false);
            DPMProfessions.ApplyFreeTrait(prof, 'NightOwl', false);
        end
    },
    {
        type = "dpm_botanist",
        name = "Botanist",
        icon = "dpm_botanist.png",
        cost = 0,
        desc = "",
        perks = {
            PlantScavenging = 1,
            Farming = 2
        },
        free_perks = function(prof)
        end
    },
    {
        type = "dpm_referee",
        name = "Referee",
        icon = "dpm_referee.png",
        cost = 0,
        desc = "",
        perks = {
            Fitness = 2,
            Sprinting = 2
        },
        free_perks = function(prof)
            DPMProfessions.ApplyFreeTrait(prof, 'dpm_Outdoorsman', false);
        end
    },
    {
        type = "dpm_offshore_worker",
        name = "Offshore Worker",
        icon = "dpm_offshore_worker.png",
        cost = 0,
        desc = "",
        perks = {
            Strength = 2,
            Electricity = 3,
            MetalWelding = 1
        },
        free_perks = function(prof)
            DPMProfessions.ApplyFreeTrait(prof, 'dpm_Strong', false);
        end
    },
    {
        type = "dpm_surgeon",
        name = "Surgeon",
        icon = "dpm_surgeon.png",
        cost = 0,
        desc = "",
        perks = {
            Doctor = 3,
            Maintenance = 1,
            SmallBlade = 1
        },
        free_perks = function(prof)
        end
    },
    {
        type = "dpm_zookeeper",
        name = "Zookeeper",
        icon = "dpm_zookeeper.png",
        cost = 0,
        desc = "",
        perks = {
            Aiming = 2,
            PlantScavenging = 2,
            Farming = 1,
            Fitness = 1
        },
        free_perks = function(prof)

        end
    },
    {
        type = "dpm_paparazzi",
        name = "Paparazzi",
        icon = "dpm_paparazzi.png",
        cost = 0,
        desc = "",
        perks = {
            Sneak = 3,
            Lightfoot = 2
        },
        free_perks = function(prof)
            DPMProfessions.ApplyFreeTrait(prof, 'dpm_Cowardly', false);
        end
    },
    {
        type = "dpm_professional_athlete",
        name = "Professional Athlete",
        icon = "dpm_professional_athlete_basketball.png",
        cost = 0,
        desc = "",
        perks = {
            Sprinting = 4,
            Strength = 4,
            Fitness = 4
        },
        free_perks = function(prof)
        end
    },
    {
        type = "dpm_correctional_officer",
        name = "Correctional Officer",
        icon = "dpm_correctional_officer.png",
        cost = 0,
        desc = "",
        perks = {
            Strength = 2,
            Fitness = 1
        },
        free_perks = function(prof)
            DPMProfessions.ApplyFreeTrait(prof, 'dpm_Brave', false);
        end
    },
    {
        type = "dpm_lawyer",
        name = "Lawyer",
        icon = "dpm_lawyer.png",
        cost = 0,
        desc = "",
        perks = {

        },
        free_perks = function(prof)
            DPMProfessions.ApplyFreeTrait(prof, 'dpm_Brave', false);
            DPMProfessions.ApplyFreeTrait(prof, 'dpm_FastReader', true);
        end
    },
    {
        type = "dpm_entrepreneur",
        name = "Entrepreneur",
        icon = "dpm_entrepreneur.png",
        cost = 0,
        desc = "",
        perks = {},
        free_perks = function(prof)
            DPMProfessions.ApplyFreeTrait(prof, 'dpm_natural_learner', true);
        end
    },
    {
        type = "dpm_architect",
        name = "Architect",
        icon = "dpm_architect.png",
        cost = 0,
        desc = "",
        perks = {
            Woodwork = 4
        },
        free_perks = function(prof)

        end
    }
}

function DPMProfessions.GetPassiveSkillCost(prof)
    -- Formula v1
    -- Calculate the passive's cost: Strength and Fitness
    local passiveCost = 0
    if prof['perks']['Strength'] ~= nil then
        local strengthValue = prof['perks']['Strength']
        if strengthValue == 2 then
            passiveCost = passiveCost - 4
        elseif strengthValue == 3 then
            passiveCost = passiveCost - 5
        elseif strengthValue == 4 then
            passiveCost = passiveCost - 8
        elseif strengthValue == 5 then
            passiveCost = passiveCost - 10
        elseif strengthValue == 6 then
            passiveCost = passiveCost - 16
        end
    end
    if prof['perks']['Fitness'] ~= nil then
        local fitnessValue = prof['perks']['Fitness']
        if fitnessValue == 2 then
            passiveCost = passiveCost - 4
        elseif fitnessValue == 3 then
            passiveCost = passiveCost - 5
        elseif fitnessValue == 4 then
            passiveCost = passiveCost - 8
        elseif fitnessValue == 5 then
            passiveCost = passiveCost - 10
        elseif fitnessValue == 6 then
            passiveCost = passiveCost - 16
        end
    end
    return passiveCost
end

function DPMProfessions.GetSprintingSkillCost(prof)
    -- Sprinting
    local cost = 0
    if prof['perks']['Sprinting'] ~= nil then
        local skillValue = prof['perks']['Sprinting']
        if skillValue == 2 then
            cost = cost - 1
        elseif skillValue == 3 then
            cost = cost - 2
        elseif skillValue == 4 then
            cost = cost - 4
        elseif skillValue == 5 then
            cost = cost - 6
        elseif skillValue == 6 then
            cost = cost - 8
        elseif skillValue == 7 then
            cost = cost - 10
        elseif skillValue == 8 then
            cost = cost - 12
        elseif skillValue == 9 then
            cost = cost - 14
        elseif skillValue == 10 then
            cost = cost - 16
        end
    end
    return cost
end

function DPMProfessions.GetAgilitySkillCost(prof)
    -- Lightfoot, Nimble, Sneak
    local cost = 0

    function CalculationHelper(skillValue)
        if skillValue == 1 then
            return -1
        elseif skillValue == 2 then
            return -2
        elseif skillValue == 3 then
            return -4
        elseif skillValue == 4 then
            return -6
        elseif skillValue == 5 then
            return -8
        elseif skillValue == 6 then
            return -10
        elseif skillValue == 7 then
            return -12
        elseif skillValue == 8 then
            return -14
        elseif skillValue == 9 then
            return -16
        elseif skillValue == 10 then
            return -18
        end
    end

    if prof['perks']['Lightfoot'] ~= nil then
        local skillValue = prof['perks']['Lightfoot']
        cost = cost + CalculationHelper(skillValue)
    elseif prof['perks']['Nimble'] ~= nil then
        local skillValue = prof['perks']['Nimble']
        cost = cost + CalculationHelper(skillValue)
    elseif prof['perks']['Sneak'] ~= nil then
        local skillValue = prof['perks']['Sneak']
        cost = cost + CalculationHelper(skillValue)
    end
    return cost
end

function DPMProfessions.GetCombatSkillCost(prof)
    -- Axe, Blunt, SmallBlunt, LongBlade, SmallBlade, Spear
    local cost = 0

    function CalculationHelper(skillValue)
        if skillValue == 1 then
            return 0
        elseif skillValue == 2 then
            return 0
        elseif skillValue == 3 then
            return -1
        elseif skillValue == 4 then
            return -2
        elseif skillValue == 5 then
            return -4
        elseif skillValue == 6 then
            return -6
        elseif skillValue == 7 then
            return -8
        elseif skillValue == 8 then
            return -10
        elseif skillValue == 9 then
            return -12
        elseif skillValue == 10 then
            return -16
        end
    end

    if prof['perks']['Axe'] ~= nil then
        local skillValue = prof['perks']['Axe']
        cost = cost + CalculationHelper(skillValue)
    elseif prof['perks']['Blunt'] ~= nil then
        local skillValue = prof['perks']['Blunt']
        cost = cost + CalculationHelper(skillValue)
    elseif prof['perks']['SmallBlunt'] ~= nil then
        local skillValue = prof['perks']['SmallBlunt']
        cost = cost + CalculationHelper(skillValue)
    elseif prof['perks']['LongBlade'] ~= nil then
        local skillValue = prof['perks']['LongBlade']
        cost = cost + CalculationHelper(skillValue)
    elseif prof['perks']['SmallBlade'] ~= nil then
        local skillValue = prof['perks']['SmallBlade']
        cost = cost + CalculationHelper(skillValue)
    elseif prof['perks']['Spear'] ~= nil then
        local skillValue = prof['perks']['Spear']
        cost = cost + CalculationHelper(skillValue)
    end
    return cost
end

function DPMProfessions.GetMaintenanceSkillCost(prof)
    -- Maintenance
    local cost = 0

    function CalculationHelper(skillValue)
        if skillValue == 1 then
            return -2
        elseif skillValue == 2 then
            return -4
        elseif skillValue == 3 then
            return -6
        elseif skillValue == 4 then
            return -8
        elseif skillValue == 5 then
            return -10
        elseif skillValue == 6 then
            return -12
        elseif skillValue == 7 then
            return -14
        elseif skillValue == 8 then
            return -16
        elseif skillValue == 9 then
            return -18
        elseif skillValue == 10 then
            return -20
        end
    end

    if prof['perks']['Maintenance'] ~= nil then
        local skillValue = prof['perks']['Maintenance']
        cost = cost + CalculationHelper(skillValue)
    end

    return cost
end

function DPMProfessions.GetBasicCraftingSkillCost(prof)
    -- Woodwork, Cooking, Farming, Doctor
    local cost = 0

    function CalculationHelper(skillValue)
        if skillValue == 1 then
            return 0
        elseif skillValue == 2 then
            return 0
        elseif skillValue == 3 then
            return -1
        elseif skillValue == 4 then
            return -2
        elseif skillValue == 5 then
            return -4
        elseif skillValue == 6 then
            return -6
        elseif skillValue == 7 then
            return -8
        elseif skillValue == 8 then
            return -10
        elseif skillValue == 9 then
            return -12
        elseif skillValue == 10 then
            return -16
        end
    end

    if prof['perks']['Woodwork'] ~= nil then
        local skillValue = prof['perks']['Woodwork']
        cost = cost + CalculationHelper(skillValue)
    elseif prof['perks']['Cooking'] ~= nil then
        local skillValue = prof['perks']['Cooking']
        cost = cost + CalculationHelper(skillValue)
    elseif prof['perks']['Farming'] ~= nil then
        local skillValue = prof['perks']['Farming']
        cost = cost + CalculationHelper(skillValue)
    elseif prof['perks']['Doctor'] ~= nil then
        local skillValue = prof['perks']['Doctor']
        cost = cost + CalculationHelper(skillValue)
    end

    return cost
end

function DPMProfessions.GetAdvancedCraftingSkillCost(prof)
    -- Electricity, MetalWelding, Mechanics, Tailoring
    local cost = 0

    function CalculationHelper(skillValue)
        if skillValue == 1 then
            return 0
        elseif skillValue == 2 then
            return -2
        elseif skillValue == 3 then
            return -4
        elseif skillValue == 4 then
            return -6
        elseif skillValue == 5 then
            return -10
        elseif skillValue == 6 then
            return -12
        elseif skillValue == 7 then
            return -14
        elseif skillValue == 8 then
            return -16
        elseif skillValue == 9 then
            return -18
        elseif skillValue == 10 then
            return -20
        end
    end

    if prof['perks']['Electricity'] ~= nil then
        local skillValue = prof['perks']['Electricity']
        cost = cost + CalculationHelper(skillValue)
    elseif prof['perks']['MetalWelding'] ~= nil then
        local skillValue = prof['perks']['MetalWelding']
        cost = cost + CalculationHelper(skillValue)
    elseif prof['perks']['Mechanics'] ~= nil then
        local skillValue = prof['perks']['Mechanics']
        cost = cost + CalculationHelper(skillValue)
    elseif prof['perks']['Tailoring'] ~= nil then
        local skillValue = prof['perks']['Tailoring']
        cost = cost + CalculationHelper(skillValue)
    end

    return cost
end

function DPMProfessions.GetFirearmSkillCost(prof)
    -- Aiming, Reloading
    local cost = 0

    function CalculationHelper(skillValue)
        if skillValue == 1 then
            return 0
        elseif skillValue == 2 then
            return -1
        elseif skillValue == 3 then
            return -2
        elseif skillValue == 4 then
            return -4
        elseif skillValue == 5 then
            return -6
        elseif skillValue == 6 then
            return -8
        elseif skillValue == 7 then
            return -10
        elseif skillValue == 8 then
            return -12
        elseif skillValue == 9 then
            return -14
        elseif skillValue == 10 then
            return -16
        end
    end

    if prof['perks']['Aiming'] ~= nil then
        local skillValue = prof['perks']['Aiming']
        cost = cost + CalculationHelper(skillValue)
    elseif prof['perks']['Reloading'] ~= nil then
        local skillValue = prof['perks']['Reloading']
        cost = cost + CalculationHelper(skillValue)
    end

    return cost
end

function DPMProfessions.GetSurvivalistSkillCost(prof)
    -- Fishing, Trapping, PlantScavenging
    local cost = 0

    function CalculationHelper(skillValue)
        if skillValue == 1 then
            return 0
        elseif skillValue == 2 then
            return -1
        elseif skillValue == 3 then
            return -2
        elseif skillValue == 4 then
            return -4
        elseif skillValue == 5 then
            return -6
        elseif skillValue == 6 then
            return -8
        elseif skillValue == 7 then
            return -10
        elseif skillValue == 8 then
            return -12
        elseif skillValue == 9 then
            return -14
        elseif skillValue == 10 then
            return -16
        end
    end

    if prof['perks']['Fishing'] ~= nil then
        local skillValue = prof['perks']['Fishing']
        cost = cost + CalculationHelper(skillValue)
    elseif prof['perks']['Trapping'] ~= nil then
        local skillValue = prof['perks']['Trapping']
        cost = cost + CalculationHelper(skillValue)
    elseif prof['perks']['PlantScavenging'] ~= nil then
        local skillValue = prof['perks']['PlantScavenging']
        cost = cost + CalculationHelper(skillValue)
    end

    return cost
end

DPMProfessions.DoProfessions = function()
    print("Interpreting configuration.")
    for _, v in pairs(DPMProfessionsConfig) do
        -- Calculate the cost
        local professionCost = 0 -- set this value to add free points
        professionCost = professionCost + DPMProfessions.GetPassiveSkillCost(v)
        professionCost = professionCost + DPMProfessions.GetSprintingSkillCost(v)
        professionCost = professionCost + DPMProfessions.GetAgilitySkillCost(v)
        professionCost = professionCost + DPMProfessions.GetCombatSkillCost(v)
        professionCost = professionCost + DPMProfessions.GetMaintenanceSkillCost(v)
        professionCost = professionCost + DPMProfessions.GetBasicCraftingSkillCost(v)
        professionCost = professionCost + DPMProfessions.GetAdvancedCraftingSkillCost(v)
        professionCost = professionCost + DPMProfessions.GetFirearmSkillCost(v)
        professionCost = professionCost + DPMProfessions.GetSurvivalistSkillCost(v)
        print("Calculated cost of " .. v['name'] .. ": " .. professionCost)
        local temp = ProfessionFactory.addProfession(v['type'], v['name'], v['icon'], professionCost);
        for perks_name, perks_value in pairs(v['perks']) do
            if perks_value ~= -100 then
                temp:addXPBoost(DPMPerkMapping[perks_name], perks_value);
            end
        end
        v['free_perks'](temp)
        print("Successfully added " .. v['name'])
    end
    print("DPM Professions have been added, now updating descriptions.")
    local profList = ProfessionFactory.getProfessions()
    for i = 1, profList:size() do
        local prof = profList:get(i - 1)
        DPMProfessions.SetProfessionDescription(prof)
    end
end

DPMProfessions.DoNewGame = function(playerObj, square)
    -- https://zomboid-javadoc.com/41.65/zombie/characters/SurvivorDesc.html
    local profession = playerObj:getDescriptor():getProfession();
    if SandboxVars.StarterKit then
        if string.find(profession, 'dpm') then
            local bag = playerObj:getInventory():FindAndReturn("Base.Bag_Schoolbag");
        end
    end

    local playerTraits = playerObj:getTraits();
    for i = 1, playerTraits:size() do
        local trait = playerTraits:get(i - 1);
        if trait ~= nil and trait:contains("dpm_") then
            getPlayer():getTraits():remove(trait);
            trait = string.sub(trait, 5);
            getPlayer():getTraits():add(trait);
        end
    end

    if profession == 'dpm_entrepreneur' and playerObj:getZombieKills() <= 1 then
        -- Pick three rand traits and apply a multiplier
        local tooPickFrom = {
            Perks.Cooking,
            Perks.Woodwork,
            Perks.Farming,
            Perks.Fishing,
            Perks.Trapping,
            Perks.Tailoring,
            Perks.MetalWelding,
            Perks.Mechanics,
            Perks.Electricity
        }
        for i = 1, 3 do
            local rand = ZombRand(0, 8);
            while (tooPickFrom[rand] == nil) do
                rand = ZombRand(0, 8)
            end
            getPlayer():getXp():addXpMultiplier(tooPickFrom[rand], 2.5, 0, 2)
            tooPickFrom[rand] = nil
        end
    end
end

DPMProfessions.DoDPMSetup = function()
    DPMProfessions.DoTraits();
    DPMProfessions.DoProfessions();
end

Events.OnGameBoot.Add(DPMProfessions.DoDPMSetup);
Events.OnCreateLivingCharacter.Add(DPMProfessions.DoDPMSetup);
Events.OnCreateLivingCharacter.Add(DPMProfessions.DoNewGame);