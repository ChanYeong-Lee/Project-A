using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TabElement : MonoBehaviour
{
    [SerializeField] private MenuType type;

    private RectTransform rect;
    private Button button;

    public MenuType Type => type;
    public Button Button => button;
    public RectTransform Rect => rect;

    private void Awake()
    {
        rect = GetComponent<RectTransform>();
        button = GetComponent<Button>();
    }
}
