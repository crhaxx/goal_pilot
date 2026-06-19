import 'package:goal_pilot/features/goals/data/models/anti_goal_model.dart';
import 'package:goal_pilot/features/goals/data/models/friction_point_model.dart';
import 'package:goal_pilot/features/goals/data/models/goal_decomposition_response.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal_template_id.dart';

class GoalTemplateDefinition {
  const GoalTemplateDefinition({
    required this.title,
    required this.description,
    required this.aiPrompt,
    required this.dailyHabit,
    required this.motivationalTips,
    required this.milestones,
    this.frictionPoints = const [],
    this.antiGoals = const [],
  });

  final String title;
  final String description;
  final String aiPrompt;
  final String dailyHabit;
  final String motivationalTips;
  final List<DecompositionMilestone> milestones;
  final List<FrictionPointModel> frictionPoints;
  final List<AntiGoalModel> antiGoals;

  GoalDecompositionResponse toDecompositionResponse() {
    return GoalDecompositionResponse(
      title: title,
      milestones: milestones,
      motivationalTips: motivationalTips,
      dailyHabit: dailyHabit,
      potentialFrictionPoints: frictionPoints,
      antiGoals: antiGoals,
    );
  }
}

abstract final class GoalTemplateCatalog {
  static const all = GoalTemplateId.values;

  static GoalTemplateDefinition get(GoalTemplateId id, String localeCode) {
    final isCzech = localeCode.startsWith('cs');
    return switch (id) {
      GoalTemplateId.learnLanguage =>
        isCzech ? _learnLanguageCs : _learnLanguageEn,
      GoalTemplateId.loseWeight => isCzech ? _loseWeightCs : _loseWeightEn,
      GoalTemplateId.finishProject =>
        isCzech ? _finishProjectCs : _finishProjectEn,
    };
  }

  static const _learnLanguageEn = GoalTemplateDefinition(
    title: 'Learn a language',
    description: 'Learn a new language to conversational level',
    aiPrompt:
        'I want to learn a new language and reach conversational level within a few months. Build a practical study plan with milestones and daily micro-tasks.',
    dailyHabit: 'Study vocabulary or practice speaking for 15 minutes.',
    motivationalTips:
        'Consistency beats intensity — 15 minutes daily adds up fast. Celebrate understanding a new phrase, not perfection. Every conversation attempt is progress.',
    milestones: [
      DecompositionMilestone(
        order: 1,
        title: 'Set up your learning system',
        description: 'Choose tools and a daily routine before diving in.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Choose your target language and level goal',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Pick one app or textbook and bookmark it',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Block a fixed 15-minute daily study slot',
            activeDayOrder: 3,
          ),
        ],
      ),
      DecompositionMilestone(
        order: 2,
        title: 'Master the basics',
        description: 'Build a foundation of sounds, words, and phrases.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Learn alphabet or pronunciation rules',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Memorize 50 essential words with flashcards',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Practice greetings and self-introduction aloud',
            activeDayOrder: 3,
          ),
        ],
      ),
      DecompositionMilestone(
        order: 3,
        title: 'Build listening and speaking',
        description: 'Train your ear and mouth with active practice.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Listen to 10 minutes of beginner content daily',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Shadow short phrases out loud',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Record yourself and compare to native audio',
            activeDayOrder: 3,
          ),
        ],
      ),
      DecompositionMilestone(
        order: 4,
        title: 'Expand vocabulary and grammar',
        description: 'Grow what you can say and understand each week.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Learn 10 new words on each active day',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Complete one grammar lesson this week',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Write 3 sentences using new vocabulary',
            activeDayOrder: 3,
          ),
        ],
      ),
      DecompositionMilestone(
        order: 5,
        title: 'Hold basic conversations',
        description: 'Use the language in real situations with confidence.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Schedule a language exchange or tutor session',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Role-play common scenarios (café, directions, shopping)',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Review mistakes and add them to flashcards',
            activeDayOrder: 3,
          ),
        ],
      ),
    ],
    frictionPoints: [
      FrictionPointModel(
        milestoneOrder: 3,
        title: 'Speaking anxiety',
        warning: 'You may freeze when trying to speak aloud or with others.',
        tip: 'Start with shadowing alone, then short voice notes before live conversation.',
      ),
    ],
    antiGoals: [
      AntiGoalModel(
        title: 'Perfectionism',
        trigger: 'When you miss a word or make a grammar mistake',
        consequence: 'You stop practicing and lose momentum',
      ),
    ],
  );

  static const _learnLanguageCs = GoalTemplateDefinition(
    title: 'Naučit se jazyk',
    description: 'Naučit se nový jazyk na úroveň běžné konverzace',
    aiPrompt:
        'Chci se naučit nový jazyk a za pár měsíců zvládnout běžnou konverzaci. Sestav praktický studijní plán s milníky a denními micro-úkoly.',
    dailyHabit: '15 minut procvičuj slovíčka nebo mluvení.',
    motivationalTips:
        'Pravidelnost je důležitější než intenzita — 15 minut denně se sečte. Oslav každou novou frázi, ne dokonalost. Každý pokus o konverzaci je pokrok.',
    milestones: [
      DecompositionMilestone(
        order: 1,
        title: 'Nastavit učební systém',
        description: 'Vyber nástroje a denní rutinu ještě před startem.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Vyber cílový jazyk a úroveň, které chceš dosáhnout',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Zvol jednu appku nebo učebnici a ulož si ji',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Vyhrad si každý den pevný 15min slot na učení',
            activeDayOrder: 3,
          ),
        ],
      ),
      DecompositionMilestone(
        order: 2,
        title: 'Zvládnout základy',
        description: 'Postav základ zvuků, slov a frází.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Projdi abecedu nebo pravidla výslovnosti',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Nauč se 50 klíčových slov pomocí kartiček',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Nacvič pozdravy a představení nahlas',
            activeDayOrder: 3,
          ),
        ],
      ),
      DecompositionMilestone(
        order: 3,
        title: 'Rozjet poslech a mluvení',
        description: 'Trénuj ucho i ústa aktivním procvičováním.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Poslouchej 10 minut obsahu pro začátečníky denně',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Opakuj krátké fráze nahlas (shadowing)',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Nahraj se a porovnej s rodilým mluvčím',
            activeDayOrder: 3,
          ),
        ],
      ),
      DecompositionMilestone(
        order: 4,
        title: 'Rozšířit slovní zásobu a gramatiku',
        description: 'Každý týden rozšiř, co umíš říct a pochopit.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Nauč se 10 nových slov v každém aktivním dni',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Projdi jednu lekci gramatiky tento týden',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Napiš 3 věty s novou slovní zásobou',
            activeDayOrder: 3,
          ),
        ],
      ),
      DecompositionMilestone(
        order: 5,
        title: 'Zvládnout základní konverzaci',
        description: 'Používej jazyk v reálných situacích s jistotou.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Domluv si jazykovou výměnu nebo lekci s lektorem',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Odehraj scénáře (kavárna, cesta, nákup)',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Projdi chyby a přidej je do kartiček',
            activeDayOrder: 3,
          ),
        ],
      ),
    ],
    frictionPoints: [
      FrictionPointModel(
        milestoneOrder: 3,
        title: 'Strach z mluvení',
        warning: 'Může tě zaskočit stud, když mluvíš nahlas nebo s někým.',
        tip: 'Začni shadowingem sám, pak krátkými hlasovkami před živou konverzací.',
      ),
    ],
    antiGoals: [
      AntiGoalModel(
        title: 'Perfekcionismus',
        trigger: 'Když neznáš slovo nebo uděláš gramatickou chybu',
        consequence: 'Přestaneš cvičit a ztratíš momentum',
      ),
    ],
  );

  static const _loseWeightEn = GoalTemplateDefinition(
    title: 'Lose 5 kg',
    description: 'Lose 5 kg sustainably through nutrition and movement',
    aiPrompt:
        'I want to lose 5 kg in a healthy, sustainable way. Create a milestone plan with daily habits, nutrition steps, and realistic weekly targets.',
    dailyHabit: 'Log meals and move your body for at least 20 minutes.',
    motivationalTips:
        'Focus on habits, not the scale alone — energy and sleep improve first. Small consistent changes beat crash diets. Progress is non-linear; trust the process.',
    milestones: [
      DecompositionMilestone(
        order: 1,
        title: 'Map your baseline',
        description: 'Know where you start before changing anything.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Weigh yourself and note starting measurements',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Log what you eat for 3 days without changing habits',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Set a realistic weekly loss target (about 0.5 kg)',
            activeDayOrder: 3,
          ),
        ],
      ),
      DecompositionMilestone(
        order: 2,
        title: 'Fix your nutrition foundation',
        description: 'Improve what you eat without extreme restriction.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Add protein and vegetables to every meal',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Replace one sugary drink with water daily',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Plan lunches for the next 3 active days',
            activeDayOrder: 3,
          ),
        ],
      ),
      DecompositionMilestone(
        order: 3,
        title: 'Move more consistently',
        description: 'Build activity into your regular routine.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Walk 30 minutes on each active day',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Add two 15-minute strength sessions this week',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Take stairs instead of the elevator when possible',
            activeDayOrder: 3,
          ),
        ],
      ),
      DecompositionMilestone(
        order: 4,
        title: 'Build sustainable habits',
        description: 'Make healthy choices automatic, not forced.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Prep healthy snacks for the week',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Eat mindfully — no screens during meals',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Check portions using the hand method',
            activeDayOrder: 3,
          ),
        ],
      ),
      DecompositionMilestone(
        order: 5,
        title: 'Reach and maintain −5 kg',
        description: 'Hit the target and plan how to keep it.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Weigh weekly and adjust if progress stalls',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Celebrate non-scale wins (energy, clothes fit)',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Write your maintenance plan for after the goal',
            activeDayOrder: 3,
          ),
        ],
      ),
    ],
    frictionPoints: [
      FrictionPointModel(
        milestoneOrder: 2,
        title: 'Weekend overeating',
        warning: 'Social meals and treats can undo weekday progress.',
        tip: 'Plan one flexible meal and keep the rest of the day on track.',
      ),
    ],
    antiGoals: [
      AntiGoalModel(
        title: 'All-or-nothing thinking',
        trigger: 'After one off-plan meal or missed workout',
        consequence: 'You abandon the whole plan instead of restarting tomorrow',
      ),
    ],
  );

  static const _loseWeightCs = GoalTemplateDefinition(
    title: 'Zhubnout 5 kg',
    description: 'Zhubnout 5 kg udržitelně díky stravě a pohybu',
    aiPrompt:
        'Chci zhubnout 5 kg zdravě a udržitelně. Sestav plán s milníky, denními návyky, kroky ve stravě a realistickými týdenními cíli.',
    dailyHabit: 'Zapiš jídla a hýbej se alespoň 20 minut.',
    motivationalTips:
        'Soustřeď se na návyky, ne jen na váhu — energie a spánek se zlepší dřív. Malé konzistentní změny porazí drastické diety. Pokrok není lineární.',
    milestones: [
      DecompositionMilestone(
        order: 1,
        title: 'Zmapovat výchozí stav',
        description: 'Zjisti, odkud startuješ, než něco změníš.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Zvaž se a zapiš výchozí míry',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: '3 dny zapisuj jídla bez změny návyků',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Nastav realistický týdenní cíl (cca 0,5 kg)',
            activeDayOrder: 3,
          ),
        ],
      ),
      DecompositionMilestone(
        order: 2,
        title: 'Srovnat stravu',
        description: 'Zlepši jídlo bez extrémních restrikcí.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Ke každému jídlu přidej bílkoviny a zeleninu',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Jeden sladký nápoj denně nahraď vodou',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Naplánuj obědy na příští 3 aktivní dny',
            activeDayOrder: 3,
          ),
        ],
      ),
      DecompositionMilestone(
        order: 3,
        title: 'Pravidelně se hýbat',
        description: 'Zapoj pohyb do běžné rutiny.',
        actionSteps: [
          DecompositionActionStep(
            title: 'V každém aktivním dni choď 30 minut',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Tento týden přidej dvě 15min silové session',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Kdykoli to jde, jdi schody místo výtahu',
            activeDayOrder: 3,
          ),
        ],
      ),
      DecompositionMilestone(
        order: 4,
        title: 'Vybudovat udržitelné návyky',
        description: 'Ať jsou zdravé volby automatické, ne vynucené.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Připrav si zdravé svačiny na týden',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Jez vědomě — u jídla bez obrazovky',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Kontroluj porce metodou dlaně',
            activeDayOrder: 3,
          ),
        ],
      ),
      DecompositionMilestone(
        order: 5,
        title: 'Dosáhnout a udržet −5 kg',
        description: 'Dosáhni cíle a naplánuj, jak ho udržíš.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Váž se týdně a uprav plán, když stagnuješ',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Oslav i jiné výhry (energie, oblečení)',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Napiš plán udržení po dosažení cíle',
            activeDayOrder: 3,
          ),
        ],
      ),
    ],
    frictionPoints: [
      FrictionPointModel(
        milestoneOrder: 2,
        title: 'Víkendové přejídání',
        warning: 'Společenská jídla a pamlsky mohou smazat pokrok z týdne.',
        tip: 'Naplánuj jedno flexibilní jídlo a zbytek dne drž v kolejích.',
      ),
    ],
    antiGoals: [
      AntiGoalModel(
        title: 'Myšlení všechno nebo nic',
        trigger: 'Po jednom „off-plan“ jídle nebo vynechaném tréninku',
        consequence: 'Vzdáš celý plán místo restartu zítra',
      ),
    ],
  );

  static const _finishProjectEn = GoalTemplateDefinition(
    title: 'Finish a project',
    description: 'Finish a personal or work project from idea to delivery',
    aiPrompt:
        'I want to finish a personal or work project from idea to delivery. Break it into milestones with concrete tasks for each active day.',
    dailyHabit: 'Work on the project for at least one focused 45-minute block.',
    motivationalTips:
        'Done beats perfect — ship a working version first. Break big tasks into the very next physical action. Momentum comes from closing small loops daily.',
    milestones: [
      DecompositionMilestone(
        order: 1,
        title: 'Clarify scope and success',
        description: 'Define what “done” looks like before building.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Write a one-sentence project outcome',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'List must-have vs nice-to-have features',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Set a realistic deadline with buffer time',
            activeDayOrder: 3,
          ),
        ],
      ),
      DecompositionMilestone(
        order: 2,
        title: 'Break down and schedule',
        description: 'Turn the project into a weekly execution plan.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Split the project into weekly deliverables',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Block focused work sessions in your calendar',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Identify dependencies and blockers early',
            activeDayOrder: 3,
          ),
        ],
      ),
      DecompositionMilestone(
        order: 3,
        title: 'Execute the core work',
        description: 'Make steady progress on the most important parts.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Complete the highest-impact task first each active day',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Time-box deep work to 45-minute blocks',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'End each session by noting the next step',
            activeDayOrder: 3,
          ),
        ],
      ),
      DecompositionMilestone(
        order: 4,
        title: 'Review, test, and refine',
        description: 'Find issues before you call it finished.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Run through the full user flow yourself',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Fix the top 3 issues found in testing',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Get feedback from one trusted reviewer',
            activeDayOrder: 3,
          ),
        ],
      ),
      DecompositionMilestone(
        order: 5,
        title: 'Ship and wrap up',
        description: 'Deliver the project and capture lessons learned.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Final polish on docs and presentation',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Deploy or deliver the finished project',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Retrospective: what worked, what to improve',
            activeDayOrder: 3,
          ),
        ],
      ),
    ],
    frictionPoints: [
      FrictionPointModel(
        milestoneOrder: 3,
        title: 'Scope creep',
        warning: 'New ideas mid-project can delay shipping indefinitely.',
        tip: 'Park new ideas in a backlog and finish the must-haves first.',
      ),
    ],
    antiGoals: [
      AntiGoalModel(
        title: 'Endless polishing',
        trigger: 'When the core work is done but it does not feel perfect',
        consequence: 'The project never ships and motivation fades',
      ),
    ],
  );

  static const _finishProjectCs = GoalTemplateDefinition(
    title: 'Dokončit projekt',
    description: 'Dokončit osobní nebo pracovní projekt od nápadu po dodání',
    aiPrompt:
        'Chci dokončit osobní nebo pracovní projekt od nápadu po dodání. Rozděl ho na milníky s konkrétními úkoly pro každý aktivní den.',
    dailyHabit: 'Věnuj projektu alespoň jeden soustředěný 45min blok.',
    motivationalTips:
        'Hotovo je lepší než dokonalé — nejdřív dodaj fungující verzi. Velké úkoly rozděl na nejbližší fyzickou akci. Momentum buduje denní uzavírání malých smyček.',
    milestones: [
      DecompositionMilestone(
        order: 1,
        title: 'Ujasnit rozsah a úspěch',
        description: 'Definuj, co znamená „hotovo“, než začneš stavět.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Napiš výsledek projektu v jedné větě',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Rozděl must-have a nice-to-have funkce',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Nastav realistický termín s rezervou',
            activeDayOrder: 3,
          ),
        ],
      ),
      DecompositionMilestone(
        order: 2,
        title: 'Rozdělit a naplánovat',
        description: 'Převeď projekt na týdenní plán exekuce.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Rozděl projekt na týdenní deliverables',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Vyhrad si v kalendáři bloky soustředěné práce',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Včas identifikuj závislosti a blokery',
            activeDayOrder: 3,
          ),
        ],
      ),
      DecompositionMilestone(
        order: 3,
        title: 'Odmakat jádro projektu',
        description: 'Dělej stabilní pokrok v nejdůležitějších částech.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Každý aktivní den dokonči nejdůležitější úkol jako první',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Deep work time-boxuj na 45min bloky',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Na konci session zapiš další krok',
            activeDayOrder: 3,
          ),
        ],
      ),
      DecompositionMilestone(
        order: 4,
        title: 'Zkontrolovat, otestovat, doladit',
        description: 'Najdi problémy dřív, než to označíš za hotové.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Projdi celý user flow sám',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Oprav 3 největší problémy z testování',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Získej feedback od jednoho důvěryhodného reviewer',
            activeDayOrder: 3,
          ),
        ],
      ),
      DecompositionMilestone(
        order: 5,
        title: 'Dodat a uzavřít',
        description: 'Dodej projekt a zapiš ponaučení.',
        actionSteps: [
          DecompositionActionStep(
            title: 'Dolaď dokumentaci a prezentaci',
            activeDayOrder: 1,
          ),
          DecompositionActionStep(
            title: 'Deployni nebo odevzdej hotový projekt',
            activeDayOrder: 2,
          ),
          DecompositionActionStep(
            title: 'Retrospektiva: co fungovalo, co zlepšit',
            activeDayOrder: 3,
          ),
        ],
      ),
    ],
    frictionPoints: [
      FrictionPointModel(
        milestoneOrder: 3,
        title: 'Scope creep',
        warning: 'Nové nápady uprostřed projektu mohou oddálit dodání.',
        tip: 'Nové nápady dej do backlogu a nejdřív dodělej must-have.',
      ),
    ],
    antiGoals: [
      AntiGoalModel(
        title: 'Nekonečné ladění',
        trigger: 'Když je jádro hotové, ale nepřijde ti to dokonalé',
        consequence: 'Projekt se nikdy nedodá a motivace vyprchá',
      ),
    ],
  );
}
