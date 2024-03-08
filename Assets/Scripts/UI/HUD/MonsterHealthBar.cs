public class MonsterHealthBar : HealthBar
{
    private void Update()
    {
        var rate = (float)Managers.Game.Monster.CurrentStat.HealthPoint /
                   Managers.Game.Monster.Data.Stats.Find(stat => stat.Level == Managers.Game.Monster.CurrentLevel).HealthPoint;
        images["FillAmount"].fillAmount = rate;
    }
}