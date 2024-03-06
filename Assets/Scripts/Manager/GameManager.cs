using UnityEngine;


public class GameManager
{
    // Game System
    private bool isUI;
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
    private Inventory inventory;
    private GameObject horse;
    private CameraController cam;

    public GameObject Player { get => player; set => player = value; }
    public Inventory Inventory { get => inventory; set => inventory = value; }
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
        if (player == null)
        {
            GameObject go = GameObject.Find("Character");
            player = go == null ? Managers.Resource.Instantiate("Prefabs/Test/Character") : go;

            inventory = player.GetComponentInChildren<Inventory>();
            if (inventory == null)
            {
                inventory = new GameObject("Inventory").AddComponent<Inventory>();
                inventory.transform.parent = player.transform;
            }
        }

        if (horse == null)
        {
            GameObject go = GameObject.Find("Horse");
            horse = go == null ? Managers.Resource.Instantiate("Prefabs/Test/Horse") : go;
        }

        if (cam == null)
        {
            GameObject go = GameObject.Find("TPSCam");
            cam = (go == null ? Managers.Resource.Instantiate("Prefabs/Test/TPSCam") : go)
                .GetComponent<CameraController>();
        }
        
        // 생성될 위치 입력
        PlayerSettings();
    }

    private void CreateMonster()
    {
        monsterSpawner = Managers.Resource.Instantiate("Prefabs/Monster/Monster Spawner").GetComponent<MonsterSpawner>();
    }

    private void PlayerSettings()
    {
        player.transform.position = new Vector3(-240, 0.5f, -241);
        player.transform.rotation = Quaternion.Euler(0, 30, 0);
        horse.transform.position = new Vector3(-235, 2, -227);
        horse.transform.rotation = Quaternion.Euler(0, 145, 0);
    }
}