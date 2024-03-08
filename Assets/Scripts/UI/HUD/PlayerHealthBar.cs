public class PlayerHealthBar : HealthBar
{
    private Player player;

    private void Start()
    {
        player = Managers.Game.Player.GetComponent<Player>();
    }

    private void Update()
    {
        var rate = (float)player.CurrentStat.HealthPoint /
                   player.Data.Stats.Find(stat => stat.Level == player.CurrentLevel).HealthPoint;
        images["FillAmount"].fillAmount = rate;
    }
}