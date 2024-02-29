using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class Managers : MonoBehaviour
{
    #region ΩÃ±€≈Ê

    private static Managers instance;

    public static Managers Instance
    {
        get
        {
            Init();

            return instance;
        }
    }

    private static void Init()
    {
        if (instance == null)
        {
            GameObject go = GameObject.Find("Managers");

            if (go == null)
            {
                go = new GameObject("Managers");
                go.AddComponent<Managers>();
            }

            DontDestroyOnLoad(go);
            instance = go.GetComponent<Managers>();
        }

        
    }

    #endregion

    private static GameManager game;
    private PoolManager pool = new PoolManager();
    private SceneLoadManager scene = new SceneLoadManager();
    private ResourceManager resource = new ResourceManager();
    private UIManager ui = new UIManager();
    private DataManager data = new DataManager();

    public static GameManager Game => game;
    public static PoolManager Pool => Instance?.pool;
    public static SceneLoadManager Scene => Instance?.scene;
    public static ResourceManager Resource => Instance?.resource;
    public static UIManager UI => Instance?.ui;
    public static DataManager Data => Instance?.data;


    private void Awake()
    {
        game = new GameObject("GameManager").AddComponent<GameManager>();
        game.transform.SetParent(Instance.transform);

        Game.Init();
        Data.Init();
    }
}
