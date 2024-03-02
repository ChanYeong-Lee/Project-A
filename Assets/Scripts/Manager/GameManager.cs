using UnityEngine;


public class GameManager
{
    // Game System
    private bool isPause;
    private bool isFullScreen;
    private float gameSpeed;
    
    public bool IsPause
    {
        get => isPause;
        set
        {
            isPause = value;
            Time.timeScale = isPause ? 0 : 1;
        }
    }
    public bool IsFullScreenMode
    {
        get => isFullScreen;
        set
        { 
            isFullScreen = value;
            Screen.fullScreen = isFullScreen;
        }
    }
    public float GameSpeed
    {
        get => gameSpeed;
        set
        {
            gameSpeed = value;
            Time.timeScale = gameSpeed;
            isPause = gameSpeed == 0;
        }
    }

    
    // Player
    private GameObject player;
    private GameObject horse;
    private CameraController cam;

    public GameObject Player { get => player; set => player = value; }
    public GameObject Horse { get => horse; set => horse = value; }
    public CameraController Cam { get => cam; set => cam = value; }
    
    
    // Monster
    private MonsterSpawner monsterSpawner;

    public MonsterSpawner MonsterSpawner { get => monsterSpawner; set => monsterSpawner = value; }
    
    
    public void Init()
    {
        CreatePlayer();
        CreateMonster();
    }
    
    private void CreatePlayer()
    {
        player = Managers.Resource.Instantiate("Prefabs/Player/Character");
        horse = Managers.Resource.Instantiate("Prefabs/Player/Horse");
        cam = Managers.Resource.Instantiate("Prefabs/Player/TPSCam").GetComponent<CameraController>();
        
        // 생성될 위치 입력
        
    }

    private void CreateMonster()
    {
        monsterSpawner = Managers.Resource.Instantiate("Prefabs/Monster/Monster Spawner").GetComponent<MonsterSpawner>();
        // Vector3(-105.138504,9.34560871,95.6413116)
        monsterSpawner.transform.position = new Vector3(-105, 3, 95);
    }

    private void PlayerSettings()
    {
    }
}