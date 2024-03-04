using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainTab : MonoBehaviour
{
    [SerializeField] private List<TabElement> tabs;
    [SerializeField] private RectTransform indicator;
    [SerializeField] private Vector3 offset = new Vector3(-0.25f, +0.25f, 0.0f);

    private Coroutine IndicatorAnimationCoroutine;

    public List<TabElement> Tabs => tabs;

    public void SelectMenu(MenuType menuType)
    {
        TabElement tab = tabs.Find((element) => element.Type == menuType);
        if (tab == null)
        {
            return;
        }

        if (IndicatorAnimationCoroutine != null)
        {
            StopCoroutine(IndicatorAnimationCoroutine);
            IndicatorAnimationCoroutine = null;
        }

        IndicatorAnimationCoroutine = StartCoroutine(AnimationHelper.Move(indicator, tab.Rect.position + offset, 5.0f));
    }
}
