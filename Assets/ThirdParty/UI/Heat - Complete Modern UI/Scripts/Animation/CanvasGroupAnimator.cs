using System.Collections;
using UnityEngine;

namespace Michsky.UI.Heat
{
    [AddComponentMenu("Heat UI/Animation/Canvas Group Animator")]
    public class CanvasGroupAnimator : MonoBehaviour
    {
        [Header("Resources")]
        [SerializeField] private CanvasGroup canvasGroup;

        [Header("Settings")]
        [Tooltip("Enable or disable the object after the animation.")]
        [SerializeField] private bool setActive = true;
        [Range(0.5f, 10)] public float fadeSpeed = 4f;
        [SerializeField] private StartBehaviour startBehaviour;

        public enum StartBehaviour { Default, FadeIn, FadeOut }

        void Start()
        {
            if (canvasGroup == null) { canvasGroup = GetComponent<CanvasGroup>(); }
            if (startBehaviour == StartBehaviour.FadeIn) { FadeIn(); }
            else if (startBehaviour == StartBehaviour.FadeOut) { FadeOut(); }
        }

        public void FadeIn()
        {
            canvasGroup.gameObject.SetActive(true);

            StopCoroutine("FadeOutHelper");
            StopCoroutine("FadeInHelper");
            StartCoroutine("FadeInHelper");
        }

        public void FadeOut()
        {
            canvasGroup.gameObject.SetActive(true);

            StopCoroutine("FadeInHelper");
            StopCoroutine("FadeOutHelper");
            StartCoroutine("FadeOutHelper");
        }

        IEnumerator FadeInHelper()
        {    
            canvasGroup.alpha = 0;
            canvasGroup.interactable = true;
            canvasGroup.blocksRaycasts = true;

            while (canvasGroup.alpha < 0.99)
            {
                canvasGroup.alpha += fadeSpeed * Time.unscaledDeltaTime;
                yield return null;
            }

            canvasGroup.alpha = 1;
        }

        IEnumerator FadeOutHelper()
        {
            canvasGroup.alpha = 1;

            while (canvasGroup.alpha > 0.01)
            {
                canvasGroup.alpha -= fadeSpeed * Time.unscaledDeltaTime;
                yield return null;
            }

            canvasGroup.alpha = 0;
            canvasGroup.interactable = false;
            canvasGroup.blocksRaycasts = false;

            if (setActive) 
            { 
                canvasGroup.gameObject.SetActive(false); 
            }
        }
    }
}