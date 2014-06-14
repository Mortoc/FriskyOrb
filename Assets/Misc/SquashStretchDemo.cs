using UnityEngine;
using System.Collections;

public class SquashStretchDemo : MonoBehaviour {

    public float stretchScale = 2.0f;
    public float stretchSpeed = 4.0f;

	IEnumerator Start() 
    {
        while(gameObject)
        {

            float stretch = 0.0f;

            foreach (Material mat in renderer.materials)
                mat.SetFloat("_stretch", 0.0f);

            yield return new WaitForSeconds(1.0f);

            for (float t = 0.0f; t < Mathf.PI * 4.0f / stretchSpeed; t += Time.deltaTime)
            {
                float phase = Mathf.Sin(t * stretchSpeed);

                stretch = stretchScale * phase;
                foreach (Material mat in renderer.materials)
                    mat.SetFloat("_stretch", stretch);

                yield return 0;
            }
            
        }
        
	}
}
