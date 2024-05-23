using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class Managers : MonoBehaviour
{
    #region ΩÃ±€≈Ê

    private static Managers _instance;
    private static bool _isQuitting;

    public static Managers Instance
    {
        get
        {
            Init();
            return _instance;
        }
    }

    private static void Init()
    {
        if (!_isQuitting && _instance == null)
        {
            GameObject go = GameObject.Find("Managers");
            
            if (go == null) 
                go = new GameObject("Managers");

            DontDestroyOnLoad(go);
            _instance = go.GetOrAddComponent<Managers>();
        }
    }

    #endregion

    private GameManager game = new GameManager();
    private PoolManager pool = new PoolManager();
    private SceneLoadManager scene = new SceneLoadManager();
    private ResourceManager resource = new ResourceManager();
    private UIManager ui = new UIManager();
    private DataManager data = new DataManager();
    private SoundManager sound = new SoundManager();
    private InputManager input;
    private CursorManager cursor;

    public static GameManager Game => Instance?.game;
    public static PoolManager Pool => Instance?.pool;
    public static SceneLoadManager Scene => Instance?.scene;
    public static ResourceManager Resource => Instance?.resource;
    public static UIManager UI => Instance?.ui;
    public static DataManager Data => Instance?.data;
    public static SoundManager Sound => Instance?.sound;
    public static InputManager Input => Instance?.input;
    public static CursorManager Cursor => Instance?.cursor;


    private void Awake()
    {
        Screen.SetResolution(1920, 1080, Game.IsFullScreenMode);
        input = resource.Instantiate("Prefabs/Managers/InputManager", transform).GetComponent<InputManager>();
        input.name = "InputManager";

        cursor = new GameObject("CursorManager").AddComponent<CursorManager>();
        cursor.transform.parent = transform;

        // game = new GameObject("GameManager").AddComponent<GameManager>();
        // game.transform.SetParent(Instance.transform);

        // Game.Init();
        // Data.Init();

        //UI.Init();
    }

    public static void Clear()
    {
        Pool.Clear();
    }
    
    private void OnApplicationQuit()
    {
        Clear();
        _isQuitting = true;
    }
}
